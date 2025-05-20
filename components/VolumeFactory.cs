using System;
using Microsoft.Extensions.Options;

public class VolumeFactory : IVolumeFactory
{
    private readonly IOptionsSnapshot<VolumeConfig> config;

    public VolumeFactory(IOptionsSnapshot<VolumeConfig> config)
    {
        this.config = config;
    }

    public IVolume GetVolume(string volumeType)
    {
        var volumeConfig = config.Get(volumeType);

        return volumeType switch
        {
            "Alpine" => new Alpine(volumeConfig),
            _ => throw new ArgumentException($"Unknown volume type: {volumeType}")
        };
    }
}