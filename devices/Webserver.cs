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

    public void Start()
    {
        _ = new Domain(deviceConfig.Name, new DomainArgs
        {
            Name = deviceConfig.Name,
            Vcpu = deviceConfig.Vcpu,
            Memory = deviceConfig.Memory,
            Disks = new DomainDiskArgs
            {
                VolumeId = volume.GetId()
            },
        });
    }
}