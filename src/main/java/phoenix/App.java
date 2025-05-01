package phoenix;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

import com.pulumi.Pulumi;
import com.pulumi.libvirt.CloudinitDisk;
import com.pulumi.libvirt.CloudinitDiskArgs;
import com.pulumi.libvirt.Provider;
import com.pulumi.libvirt.ProviderArgs;
import com.pulumi.libvirt.Volume;
import com.pulumi.libvirt.VolumeArgs;

import phoenix.model.PC;
import phoenix.model.Router;;

public class App {
    public static void main(String[] args) {
        Pulumi.run(ctx -> {
            // connecting to QEMU
            var _ = new Provider(
                    "libvirtd",
                    ProviderArgs.builder()
                    .uri("qemu:///system")
                    .build()
                );

            // router cloudinit
             // router config file
            String routerCloudInit;
            try {
                routerCloudInit = Files.readString(Paths.get("src/main/resources/router.yml"));
            } catch (IOException e) {
                e.printStackTrace();
                routerCloudInit = "";
            }
            

            var volume = new Volume(
            "Alpine Cloud",
                VolumeArgs.builder()
                    .source("https://dl-cdn.alpinelinux.org/alpine/v3.21/releases/cloud/nocloud_alpine-3.21.2-x86_64-bios-cloudinit-metal-r0.qcow2")
                    .build()
                );

            var router = new Router("router", 
                new Volume("router_volume", 
                    VolumeArgs.builder()
                        .baseVolumeId(volume.volumeId())
                        .build()
                )
            )
            .setNetwork("router_network", "192.168.50.0/24")
            .setCloudInit(
                new CloudinitDisk(
                    "router_cloudinit",
                    CloudinitDiskArgs.builder()
                        .userData(routerCloudInit)
                        .metaData("instance-id: router\n" + " local-hostname: router")
                        .build()
                )
            )
            .build();

            // webserver
            var pc1 = new PC("Linux 1", new Volume("linux_1_volume", 
            VolumeArgs.builder()
                .baseVolumeId(volume.volumeId())
                .build()
            ))
            .setNetwork("linux_1_network", "192.168.100.0/24")
            .build();

            // database
            var pc2 = new PC("Linux 2", new Volume("linux_2_volume", 
            VolumeArgs.builder()
                .baseVolumeId(volume.volumeId())
                .build()
            ))
            .setNetwork("linux_2_network", "192.168.200.0/24")
            .build();

            ctx.export("Router Domain", router.id());
            ctx.export("PC1 Domain", pc1.id());
            ctx.export("PC2 Domain", pc2.id());
        });
    }
}
