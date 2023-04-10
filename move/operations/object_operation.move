module maven::object_operation {
    use sui::bcs;
    use sui::object;
    use std::vector;

    /// error code
    const E_HAS_REDUNDANT_DATA: u64 = 1000;

    /// operation types
    const OBJECT_TYPE_OBJECT_TRANSFER: u64 = 0;

    struct ObjectTransfer has store, drop, copy {
        id: object::ID,
        to: address,
    }

    public fun deserialize_object_transfer(bytes: vector<u8>): ObjectTransfer {
        let deserializer = bcs::new(bytes);
        let id = bcs::peel_address(&mut deserializer);
        let to = bcs::peel_address(&mut deserializer);
        let remainder = bcs::into_remainder_bytes(deserializer);
        assert!(vector::length(&remainder) == 0, E_HAS_REDUNDANT_DATA);
        ObjectTransfer {
            id: object::id_from_address(id),
            to,
        }
    }

    public fun object_transfer_destruct(op_spec: ObjectTransfer): (object::ID, address) {
        let ObjectTransfer { id, to } = op_spec;
        (id, to)
    }

    public fun is_object_transfer(operation_type: u64): bool {
        operation_type == OBJECT_TYPE_OBJECT_TRANSFER
    }
}
