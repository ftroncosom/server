﻿CREATE PROCEDURE [dbo].[Cipher_UpdateWithCollections]
    @Id UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @OrganizationId UNIQUEIDENTIFIER,
    @Type TINYINT,
    @Data NVARCHAR(MAX),
    @Favorites NVARCHAR(MAX),
    @Folders NVARCHAR(MAX),
    @CreationDate DATETIME2(7),
    @RevisionDate DATETIME2(7),
    @CollectionIds AS [dbo].[GuidIdArray] READONLY
AS
BEGIN
    SET NOCOUNT ON

    UPDATE
        [dbo].[Cipher]
    SET
        [UserId] = NULL,
        [OrganizationId] = @OrganizationId,
        [Data] = @Data,
        [RevisionDate] = @RevisionDate
        -- No need to update CreationDate, Favorites, Folders, or Type since that data will not change
    WHERE
        [Id] = @Id

    ;WITH [AvailableCollectionsCTE] AS(
        SELECT
            S.[Id]
        FROM
            [dbo].[Collection] S
        INNER JOIN
            [Organization] O ON O.[Id] = S.[OrganizationId]
        INNER JOIN
            [dbo].[OrganizationUser] OU ON OU.[OrganizationId] = O.[Id] AND OU.[UserId] = @UserId
        LEFT JOIN
            [dbo].[CollectionUser] SU ON OU.[AccessAllCollections] = 0 AND SU.[CollectionId] = S.[Id] AND SU.[OrganizationUserId] = OU.[Id]
        WHERE
            O.[Id] = @OrganizationId
            AND O.[Enabled] = 1
            AND OU.[Status] = 2 -- Confirmed
            AND (OU.[AccessAllCollections] = 1 OR SU.[ReadOnly] = 0)
    )
    INSERT INTO [dbo].[CollectionCipher]
    (
        [CollectionId],
        [CipherId]
    )
    SELECT
        [Id],
        @Id
    FROM
        @CollectionIds
    WHERE
        [Id] IN (SELECT [Id] FROM [AvailableCollectionsCTE])

    IF @OrganizationId IS NOT NULL
    BEGIN
        EXEC [dbo].[User_BumpAccountRevisionDateByOrganizationId] @OrganizationId
    END
    ELSE IF @UserId IS NOT NULL
    BEGIN
        EXEC [dbo].[User_BumpAccountRevisionDate] @UserId
    END
END