﻿using System;

namespace Bit.Core.Models.Data
{
    public class CollectionUserUserDetails
    {
        public Guid? Id { get; set; }
        public Guid OrganizationUserId { get; set; }
        public Guid? CollectionId { get; set; }
        public bool AccessAllCollections { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public Enums.OrganizationUserStatusType Status { get; set; }
        public Enums.OrganizationUserType Type { get; set; }
        public bool ReadOnly { get; set; }
    }
}
