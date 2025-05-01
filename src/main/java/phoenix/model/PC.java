package phoenix.model;

import com.pulumi.libvirt.Domain;
import com.pulumi.libvirt.DomainArgs;
import com.pulumi.libvirt.Network;
import com.pulumi.libvirt.NetworkArgs;
import com.pulumi.libvirt.Volume;
import com.pulumi.libvirt.inputs.DomainDiskArgs;
import com.pulumi.libvirt.inputs.DomainNetworkInterfaceArgs;

import lombok.NonNull;

public class PC {
    private double vcpu;
    private double memory;
    private Volume volume;
    private String name;
    private Network network;

    public PC(@NonNull String name, @NonNull Volume volume) {
        this.name = name;
        this.vcpu = 2.0;
        this.memory = 512.0;
        this.volume = volume;
    }

    public PC setNetwork(String name, String subnet) {
        this.network = new Network(
            name,
            NetworkArgs.builder()
                .addresses(subnet)
                .mode("nat")
                .build()
        );

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
