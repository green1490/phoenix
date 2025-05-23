using Microsoft.Extensions.DependencyInjection;
using Pulumi;

return await Deployment.RunAsync(() =>
{
    var webserverConfig = new Config("Webserver");
    var databaseConfig = new Config("Database");
    var volumeConfig = new Config("Alpine");

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
        .AddSingleton(new VolumeConfig()
        {
            Name = volumeConfig.Require("Name"),
            Src = volumeConfig.Require("Src")
        })
        .AddSingleton<IVolume, Alpine>()
        .AddSingleton<IDevice>(provider =>
        {
            var volume = provider.GetRequiredService<IVolume>();
            var deviceConfig = provider.GetRequiredService<DeviceConfig>();
            return new Webserver(deviceConfig, volume);
        })
        .BuildServiceProvider();
    var volume = services.GetRequiredService<IVolume>().Build();

    var webServer = services.GetRequiredService<IDevice>();
    webServer.Start();
});
