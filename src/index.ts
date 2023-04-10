import {JsonRpcProvider, testnetConnection} from "@mysten/sui.js";

const MAVEN_PACKAGE = "0xbc3f8e53ab0656ceea692f1e1f292064e586b2b2c9b136d661d8ef636ce726d9";

const MODULES = [
  "admin_operation",
  "coin_operation",
  "object_operation",
]

async function main() {
  const provider = new JsonRpcProvider(testnetConnection);
  const module = await provider.getNormalizedMoveModule({
    package: MAVEN_PACKAGE,
    module: MODULES[0],
  });
  console.log(module);
  console.log("Data Fields: ", module.structs.UpdatePermission);
  console.log("Data Type: ", module.structs.UpdatePermission.fields[0].type);
}

main().then( () => {
  console.log("successfully executed");
})

