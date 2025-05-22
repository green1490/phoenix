using System;
using Microsoft.Extensions.Options;

public class DeviceFactory : IDeviceFactory
{
    private readonly DeviceConfig deviceConfig;
    private readonly IVolumeFactory volumeFactory;

    public DeviceFactory(IOptions<DeviceConfig> config, IVolumeFactory volumeFactory)
    {
        deviceConfig = config.Value;
        this.volumeFactory = volumeFactory;
    }

    public IDevice CreateDevice(string deviceType, string volumeType)
    {
        var volume = volumeFactory.GetVolume(volumeType);

        return deviceType switch
        {
            "Webserver" => new Webserver(deviceConfig, volume),
            _ => throw new ArgumentException($"Unknown device type: {deviceType}")
        };

    }
}