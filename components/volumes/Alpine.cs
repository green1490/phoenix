using Pulumi.Libvirt;

public class Alpine : IVolume
{
    private readonly VolumeConfig config;
    
    public Alpine(VolumeConfig config)
    {
        this.config = config;
    }

    public Volume Build()
    {
        return new Volume(config.Name, new VolumeArgs
        {
            Source = config.Src
        });
    }
}