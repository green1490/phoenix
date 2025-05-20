using System.Collections.Generic;
using Microsoft.Extensions.DependencyInjection;
using Pulumi;

return await Deployment.RunAsync(() =>
{
    var config = new Config("phoenix");

    var services = new ServiceCollection()
    .AddOptions()
    .Configure<DeviceConfig>("Webserver", _ => 
        new DeviceConfig 
        {
            Vcpu = config.RequireInt32("Webserver:Vcpu"),
            Memory = config.RequireInt32("Webserver:Memory"),
            Volume = config.Require("Webserver:Volume"),
            Name = config.Require("Webserver:Name"),
            Subnet = config.Require("Webserver:Subnet")
        })
    .Configure<DeviceConfig>("Database", _ => 
        new DeviceConfig 
        {
            Vcpu = config.RequireInt32("Database:Vcpu"),
            Memory = config.RequireInt32("Database:Memory"),
            Volume = config.Require("Database:Volume"),
            Name = config.Require("Database:Name"),
            Subnet = config.Require("Database:Subnet")
        })
    .Configure<VolumeConfig>("Alpine", _ =>
        new VolumeConfig
        {
            Src = config.Require("Alpine:Src"),
            Name = config.Require("Alpine:Name")
        })
    .AddSingleton<IDeviceFactory, DeviceFactory>()
    .AddSingleton<IVolumeFactory, VolumeFactory>()
    .BuildServiceProvider();

    var factory = services.GetRequiredService<IDeviceFactory>();
    factory.CreateDevice("Webserver", "Alpine");

    // Export outputs here
    return new Dictionary<string, object?>
    {
        ["status"] = "success"
    };
});
