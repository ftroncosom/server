﻿CREATE FUNCTION [dbo].[UserCanEditCipher](@UserId UNIQUEIDENTIFIER, @CipherId UNIQUEIDENTIFIER)
RETURNS BIT AS
BEGIN
    DECLARE @CanEdit BIT

    ;WITH [CTE] AS(
        SELECT
            CASE WHEN OU.[AccessAllCollections] = 1 OR SU.[ReadOnly] = 0 THEN 1 ELSE 0 END [CanEdit]
        FROM
            [dbo].[Cipher] C
        INNER JOIN
            [dbo].[Organization] O ON C.[UserId] IS NULL AND O.[Id] = C.[OrganizationId]
        INNER JOIN
            [dbo].[OrganizationUser] OU ON OU.[OrganizationId] = O.[Id] AND OU.[UserId] = @UserId
        LEFT JOIN
            [dbo].[CollectionCipher] SC ON C.[UserId] IS NULL AND OU.[AccessAllCollections] = 0 AND SC.[CipherId] = C.[Id]
        LEFT JOIN
            [dbo].[CollectionUser] SU ON SU.[CollectionId] = SC.[CollectionId] AND SU.[OrganizationUserId] = OU.[Id]
        WHERE
            C.[Id] = @CipherId
            AND OU.[Status] = 2 -- 2 = Confirmed
            AND O.[Enabled] = 1
            AND (OU.[AccessAllCollections] = 1 OR SU.[CollectionId] IS NOT NULL)
    )
    SELECT
        @CanEdit = CASE WHEN COUNT(1) > 0 THEN 1 ELSE 0 END
    FROM
        [CTE]
    WHERE
        [CanEdit] = 1

    RETURN @CanEdit
END