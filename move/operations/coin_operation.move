module maven::coin_operation {
    use std::ascii::String;
    use sui::bcs;
    use std::ascii;
    use std::vector;

    /// error code
    const E_HAS_REDUNDANT_DATA: u64 = 1000;

    /// operation types
    const COIN_TYPE_COIN_TRANSFER: u64 = 0;

    struct CoinTransfer {
        coin: String,
        to: address,
        amount: u64,
    }

    public fun deserialize_coin_transfer(bytes: vector<u8>): CoinTransfer {
        let deserializer = bcs::new(bytes);
        let coin = bcs::peel_vec_u8(&mut deserializer);
        let to = bcs::peel_address(&mut deserializer);
        let amount = bcs::peel_u64(&mut deserializer);
        let remainder = bcs::into_remainder_bytes(deserializer);
        assert!(vector::length(&remainder) == 0, E_HAS_REDUNDANT_DATA);
        CoinTransfer {
            coin: ascii::string(coin),
            to,
            amount,
        }
    }

    public fun coin_transfer_destruct(op_spec: CoinTransfer): (String, address, u64) {
        let CoinTransfer { coin, to, amount } = op_spec;
        (coin, to, amount)
    }

    public fun is_coin_transfer(coin_type: u64): bool {
        coin_type == COIN_TYPE_COIN_TRANSFER
    }
}
