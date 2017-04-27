﻿using Bit.Core.Repositories;
using Bit.Core.Services;
using Microsoft.Extensions.DependencyInjection;
using SqlServerRepos = Bit.Core.Repositories.SqlServer;

namespace Bit.Core
{
    public static class ServiceCollectionExtensions
    {
        public static void AddSqlServerRepositories(this IServiceCollection services)
        {
            services.AddSingleton<IUserRepository, SqlServerRepos.UserRepository>();
            services.AddSingleton<ICipherRepository, SqlServerRepos.CipherRepository>();
            services.AddSingleton<IDeviceRepository, SqlServerRepos.DeviceRepository>();
            services.AddSingleton<IGrantRepository, SqlServerRepos.GrantRepository>();
            services.AddSingleton<IOrganizationRepository, SqlServerRepos.OrganizationRepository>();
            services.AddSingleton<IOrganizationUserRepository, SqlServerRepos.OrganizationUserRepository>();
            services.AddSingleton<ICollectionRepository, SqlServerRepos.CollectionRepository>();
            services.AddSingleton<ICollectionUserRepository, SqlServerRepos.CollectionUserRepository>();
            services.AddSingleton<IFolderRepository, SqlServerRepos.FolderRepository>();
            services.AddSingleton<ICollectionCipherRepository, SqlServerRepos.CollectionCipherRepository>();
        }

        public static void AddBaseServices(this IServiceCollection services)
        {
            services.AddSingleton<ICipherService, CipherService>();
            services.AddScoped<IUserService, UserService>();
            services.AddScoped<IDeviceService, DeviceService>();
            services.AddScoped<IOrganizationService, OrganizationService>();
            services.AddScoped<ICollectionService, CollectionService>();
        }

        public static void AddDefaultServices(this IServiceCollection services)
        {
            services.AddSingleton<IMailService, SendGridMailService>();
            services.AddScoped<IPushService, PushSharpPushService>();
            services.AddScoped<IBlockIpService, AzureQueueBlockIpService>();
        }

        public static void AddNoopServices(this IServiceCollection services)
        {
            services.AddSingleton<IMailService, NoopMailService>();
            services.AddScoped<IPushService, NoopPushService>();
            services.AddScoped<IBlockIpService, NoopBlockIpService>();
        }
    }
}
