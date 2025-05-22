using System;
using Microsoft.Extensions.DependencyInjection;
using Pulumi;

return await Deployment.RunAsync(() =>
{
    var webserverConfig = new Config("Webserver");
    var databaseConfig = new Config("Database");

    var services = new ServiceCollection()
        .AddOptions()
        .AddSingleton(new DeviceConfig()
        {
            Name = webserverConfig.Require("Name"),
            Vcpu = webserverConfig.RequireDouble("Vcpu"),
            Memory = webserverConfig.RequireDouble("Memory"),
            Volume = webserverConfig.Require("Volume"),
            Subnet = webserverConfig.Require("Subnet")
        })
        .AddSingleton<IDeviceFactory, DeviceFactory>()
        .AddSingleton<IVolumeFactory, VolumeFactory>()
        .BuildServiceProvider();

    var factory = services.GetRequiredService<IDeviceFactory>();
    factory.CreateDevice("Webserver", "Alpine").Start();
});
