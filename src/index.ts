import {JsonRpcProvider, SuiMoveNormalizedModule, SuiMoveNormalizedStruct, testnetConnection} from '@mysten/sui.js'
import {writeFile} from 'fs/promises'
import {SuiMoveNormalizedStructType, SuiMoveNormalizedType} from '@mysten/sui.js/src/types/normalized'
import {mkdirSync} from 'fs'

const MAVEN_PACKAGE = "0xbc3f8e53ab0656ceea692f1e1f292064e586b2b2c9b136d661d8ef636ce726d9";
const DEFAULT_OUT_DIR = "src/types/"

const MODULES = [
  "admin_operation",
  "coin_operation",
  "object_operation",
]

const structTemplates: Array<String> = []
async function main() {
  const provider = new JsonRpcProvider(testnetConnection);
  mkdirSync(DEFAULT_OUT_DIR, {recursive: true})
  MODULES.forEach((moduleName) => {
    convertMove2TypeScript(provider, MAVEN_PACKAGE, moduleName)
  })
}

main().then( () => {
  console.log("successfully executed");
})

async function convertMove2TypeScript(provider: JsonRpcProvider, address: string, moduleName: string) {
  const module = await provider.getNormalizedMoveModule({
    package: address,
    module: moduleName,
  });

  structTemplates.splice(0, structTemplates.length)
  structTemplates.push(`import { BigNumberish } from "ethers";`)
  for (const [key, value] of Object.entries(module.structs)) {
    const fields: Array<Field> = []
    for (const field of value.fields) {
      if (typeof field.type === "string") {
        fields.push({
          name: field.name,
          type: typeMapping(field.type as string),
        })
      }else if (typeof field.type === "object") {
        await customTypeMapping(field.type).then((type) => {
          fields.push({
            name: field.name,
            type: type,
          })
        })
      }else {
        console.log("unknown", field.type)
      }
    }
    structTemplates.push(formatStructTemplate(key, fields))
    console.log("generate type", key)
  }

  await writeFile(`${DEFAULT_OUT_DIR}${moduleName}.ts`, structTemplates.join('\n\n'))
}

type Field = {
  name: String;
  type: String;
}

function formatStructTemplate(name: String, fields: Array<Field>): String {
  return `type ${name} = {
${fields.map((field) => `\t${field.name}: ${field.type}`).join('\n')}
}`
}

const typeMap = new Map([
  ["U8", "number"],
  ["U64", "BigNumberish"],
  ["U128", "BigNumberish"],
  ["Bool", "boolean"],
  ["Address", "string"],
])

function typeMapping(type: string): string {
  if (typeMap.has(type)) {
    return typeMap.get(type) as string
  }
  return "string"
}

// customTypeMapping return a custom type for a struct type
// * if the struct only contains basic types, return the struct name, eg: QueryID
// * if the struct contains other struct types, return the custom type, eg: QueryID_id_0xbc3f8e53ab0656ceea692f1e1f292064e586b2b2c9b136d661d8ef636ce726d9
async function customTypeMapping(targetType: SuiMoveNormalizedType): Promise<string> {
  const valueProperties = targetType as Record<string, unknown>;
  if (typeMap.has(getStructTypeKey(targetType))) {
    if (valueProperties.hasOwnProperty("Struct")) {
      const t = targetType as SuiMoveNormalizedStructType
      if (t.Struct.typeArguments.length > 0) {
        const genericType = await customTypeMapping(t.Struct.typeArguments[0])
        return `${typeMap.get(getStructTypeKey(targetType))}<${genericType}>`
      }
    }
    return typeMap.get(getStructTypeKey(targetType)) as string
  }else {
    if (valueProperties.hasOwnProperty("Vector")) {
      const formattedType = formatBasicType(targetType)
      if (formattedType !== "") {
        typeMap.set(getStructTypeKey(targetType), formattedType)
      }
      return formattedType
    }else if (valueProperties.hasOwnProperty("Struct")) {
      const t = targetType as SuiMoveNormalizedStructType
      const provider = new JsonRpcProvider(testnetConnection);
      const module = await provider.getNormalizedMoveModule({
        package: t.Struct.address,
        module: t.Struct.module,
      });

      // generate generic type
      if (t.Struct.typeArguments.length > 0) {
        const typeArguments: Array<String> = []
        for (const type of t.Struct.typeArguments) {
          typeArguments.push(await customTypeMapping(type))
        }
        const formattedType = `${t.Struct.name}<${typeArguments.join(", ")}>`
        typeMap.set(getStructTypeKey(t), formattedType)
      }

      for (const [key, value] of Object.entries(module.structs)) {
        if (key === t.Struct.name) {
          if (value.fields.length === 1) {
            const formattedType = formatBasicType(value.fields[0].type)
            if (formattedType !== "") {
              typeMap.set(getStructTypeKey(t), formattedType)
            }
            return formattedType
          }else {
            // need to create a custom type
            // typeArguments.length > 0 means the struct contains a generic type
            if (t.Struct.typeArguments.length > 0) {
              structTemplates.push(formatStructTemplate(`${t.Struct.name}<T>`, value.fields.map((field) => {
                return {
                  name: field.name,
                  type: formatBasicType(field.type),
                }
              }) as Array<Field>))
            }else {
              structTemplates.push(formatStructTemplate(t.Struct.name, value.fields.map((field) => {
                return {
                  name: field.name,
                  type: formatBasicType(field.type),
                }
              }) as Array<Field>))
            }

            typeMap.set(getStructTypeKey(t), t.Struct.name)
            if (t.Struct.typeArguments.length > 0) {
              const genericType = await customTypeMapping(t.Struct.typeArguments[0])
              return `${t.Struct.name}<${genericType}>`
            }
            return t.Struct.name
          }
        }
      }
    }
  }
  return ""
}

function formatBasicType(type: SuiMoveNormalizedType): string {
  if (typeof type === "string") {
    return typeMapping(type)
  }else if (typeof type === "object") {
    const valueProperties = type as Record<string, unknown>;
    if (valueProperties.hasOwnProperty("Vector")) {
      if ((type as { Vector: SuiMoveNormalizedType }).Vector === "U8") {
        return "string"
      }
      return "Array<" + formatBasicType((type as { Vector: SuiMoveNormalizedType }).Vector) + ">"
    }else if (valueProperties.hasOwnProperty("TypeParameter")) {
      return "T"
    }else {
      return "object"
    }
  }
  return ""
}

// getStructTypeKey return a unique key for a struct type
// eg: QueryID_id_0xbc3f8e53ab0656ceea692f1e1f292064e586b2b2c9b136d661d8ef636ce726d9
function getStructTypeKey(type: SuiMoveNormalizedType): string {
  const valueProperties = type as Record<string, unknown>;
  if (valueProperties.hasOwnProperty("Vector")) {
    return "Vector_" + (type as { Vector: SuiMoveNormalizedType }).Vector
  }else if (valueProperties.hasOwnProperty("Struct")) {
    const t = type as SuiMoveNormalizedStructType
    return `${t.Struct.name}_${t.Struct.module}_${t.Struct.address.length > 20 ? t.Struct.address.substring(0, 8) : t.Struct.address}`
  }else {
    return "unknown"
  }
}
