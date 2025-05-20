using Pulumi.Libvirt;
using Pulumi.Libvirt.Inputs;

public class Webserver : IDevice
{
    private readonly DeviceConfig deviceConfig;
    private readonly IVolume volume;

    public Webserver(DeviceConfig deviceConfig, IVolume volume)
    {
        this.deviceConfig = deviceConfig;
        this.volume = volume;
    }

    public Domain Start()
    {
    
        return new Domain(deviceConfig.Name, new DomainArgs
        {
            Name = deviceConfig.Name,
            Vcpu = deviceConfig.Vcpu,
            Memory = deviceConfig.Vcpu,
            Disks = new DomainDiskArgs
            {
                VolumeId = volume.Build().VolumeId
            },
        });
    }
}