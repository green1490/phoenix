using System;
using Microsoft.Extensions.Options;

public class DeviceFactory : IDeviceFactory
{
    private readonly IOptionsSnapshot<DeviceConfig> config;
    private readonly IVolumeFactory volumeFactory;

    public DeviceFactory(IOptionsSnapshot<DeviceConfig> config, IVolumeFactory volumeFactory)
    {
        this.config = config;
        this.volumeFactory = volumeFactory;
    }

    public IDevice CreateDevice(string deviceType, string volumeType)
    {
        var deviceConfig = config.Get(deviceType);
        var volume = volumeFactory.GetVolume(volumeType);

        return deviceType switch
        {
            "Webserver" => new Webserver(deviceConfig, volume),
            _ => throw new ArgumentException($"Unknown device type: {deviceType}")
        };

    }
}