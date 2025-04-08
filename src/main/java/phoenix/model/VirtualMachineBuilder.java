package phoenix.model;

import com.pulumi.libvirt.Domain;
import com.pulumi.libvirt.DomainArgs;
import com.pulumi.libvirt.Network;
import com.pulumi.libvirt.Volume;
import com.pulumi.libvirt.VolumeArgs;
import com.pulumi.libvirt.inputs.DomainDiskArgs;

import lombok.Getter;
import lombok.NonNull;
import lombok.Setter;

// default setting for 
// sets and gets the default values
@Getter
@Setter
public class VirtualMachineBuilder {
    private double vcpu;
    private double memory;
    private Volume volume;
    private String name;
    private Network network;

    public VirtualMachineBuilder(@NonNull String name) {
        this.name = name;
        this.memory = 512.0;
        this.vcpu = 2.0;
        this.volume = new Volume(
            "Alpine Cloud",
            VolumeArgs.builder()
                .source("https://dl-cdn.alpinelinux.org/alpine/v3.21/releases/cloud/nocloud_alpine-3.21.2-x86_64-bios-cloudinit-metal-r0.qcow2")
                .build()
        );
        this.network = null;
    }

    public VirtualMachineBuilder(@NonNull String name, @NonNull String source) {
        this.name = name;
        this.memory = 512.0;
        this.vcpu = 2.0;
        this.volume = new Volume(
            "Alpine Cloud",
            VolumeArgs.builder()
                .source(source)
                .build()
        );
        this.network = null;
    }

    public void setNetwork(String subnet) {
        this.network = new Network("network");
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
                .build()
        );

        return domain;
    }
}
