package phoenix;

import com.pulumi.Pulumi;
import com.pulumi.core.Output;
import com.pulumi.libvirt.Provider;
import com.pulumi.libvirt.ProviderArgs;

import phoenix.model.VirtualMachineBuilder;;

public class App {
    public static void main(String[] args) {
        Pulumi.run(ctx -> {
            // connecting to QEMU
            var provider = new Provider(
                    "libvirtd",
                    ProviderArgs.builder()
                    .uri("qemu:///system")
                    .build()
                );
            
            VirtualMachineBuilder router = new VirtualMachineBuilder("router");
            router.build();

            VirtualMachineBuilder pc1 = new VirtualMachineBuilder("pc1");

            ctx.export("Domain", Output.of("Domain"));
        });
    }
}
