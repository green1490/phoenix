package phoenix.model;

import com.pulumi.libvirt.CloudinitDisk;
import com.pulumi.libvirt.Domain;
import com.pulumi.libvirt.DomainArgs;
import com.pulumi.libvirt.Network;
import com.pulumi.libvirt.NetworkArgs;
import com.pulumi.libvirt.Volume;
import com.pulumi.libvirt.inputs.DomainDiskArgs;
import com.pulumi.libvirt.inputs.DomainNetworkInterfaceArgs;

import lombok.NonNull;

public class Router {
    private double vcpu;
    private double memory;
    private Volume volume;
    private String name;
    private Network network;
    private CloudinitDisk cloudinitDisk;

    public Router(@NonNull String name, @NonNull Volume volume) {
        this.name = name;
        this.memory = 512.0;
        this.vcpu = 2.0;
        this.volume = volume;
    }

    public Router setNetwork(@NonNull String name, @NonNull String subnet) {
        this.network = new Network(
            name,
            NetworkArgs.builder()
                .addresses(subnet)
                .build()
        );

        return this;
    }

    public Router setCloudInit(@NonNull CloudinitDisk cloudinitDisk) {
        this.cloudinitDisk = cloudinitDisk;
        return this;
    }

    public Domain build() {
        Domain domain = new Domain(
            name,
            DomainArgs.builder()
                .name(name)
                .vcpu(vcpu)
                .memory(memory)
                .disks(
                    DomainDiskArgs.builder()
                        .volumeId(volume.volumeId())
                        .build()
                )
                .cloudinit(cloudinitDisk.id())
                .networkInterfaces(
                    DomainNetworkInterfaceArgs.builder()
                    .networkId(network.id())
                    .build()
                )
                .build()
        );

        return domain;
    }
}
