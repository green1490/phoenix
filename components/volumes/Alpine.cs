using Pulumi;
using Pulumi.Libvirt;

public class Alpine : IVolume
{
    private readonly VolumeConfig config;
    private Volume? volume;

    public Alpine(VolumeConfig config)
    {
        this.config = config;
    }

    public Volume Build()
    {
        volume = new Volume(config.Name, new VolumeArgs
        {
            Source = config.Src,
            Name = config.Name
        });

        return volume;
    }
    
    public Output<string> GetId() => volume!.Id;
}