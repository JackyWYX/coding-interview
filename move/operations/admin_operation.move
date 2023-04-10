module maven::admin_operation {
    use sui::object::{Self, ID};
    use sui::bcs;
    use std::ascii::{Self, String};
    use std::vector;
    use maven::id::{Self, RoleID, PermissionID, QueryID};

    /// error code
    const E_HAS_REDUNDANT_DATA: u64 = 1000;

    /// operation types
    const ADMIN_TYPE_ROLE_RANGE_START: u64 = 0;
    const ADMIN_TYPE_CREATE_ROLE: u64 = 0;
    const ADMIN_TYPE_CREATE_SIGNER: u64 = 1;
    const ADMIN_TYPE_GRANT_ROLE: u64 = 2;
    const ADMIN_TYPE_REVOKE_ROLE: u64 = 3;
    const ADMIN_TYPE_DELETE_ROLE: u64 = 4;
    const ADMIN_TYPE_DELETE_SIGNER: u64 = 5;
    const ADMIN_TYPE_RENAME_ROLE: u64 = 6;
    const ADMIN_TYPE_ROLE_RANGE_END: u64 = 10000 - 1;

    /// permission start from 10000
    const ADMIN_TYPE_PERMISSION_RANGE_START: u64 = 10000;
    const ADMIN_TYPE_CREATE_PERMISSION: u64 = 10000;
    const ADMIN_TYPE_UPDATE_PERMISSION: u64 = 10001;
    const ADMIN_TYPE_DELETE_PERMISSION: u64 = 10002;
    const ADMIN_TYPE_PERMISSION_RANGE_END: u64 = 20000 - 1;

    /// policy start from 20000
    const ADMIN_TYPE_POLICY_RANGE_START: u64 = 20000;
    const ADMIN_TYPE_UPDATE_ADMIN_POLICY: u64 = 20000;
    const ADMIN_TYPE_UPDATE_COIN_POLICY: u64 = 20001;
    const ADMIN_TYPE_UPDATE_OBJECT_POLICY: u64 = 20002;
    const ADMIN_TYPE_UPDATE_RECOVERY_POLICY: u64 = 20003;
    const ADMIN_TYPE_DELETE_ADMIN_POLICY: u64 = 20004;
    const ADMIN_TYPE_DELETE_COIN_POLICY: u64 = 20005;
    const ADMIN_TYPE_DELETE_OBJECT_POLICY: u64 = 20006;
    const ADMIN_TYPE_DELETE_RECOVERY_POLICY: u64 = 20007;
    const ADMIN_TYPE_POLICY_RANGE_END: u64 = 30000 - 1;

    /// allowlist start from 30000
    const ADMIN_TYPE_ALLOWLIST_RANGE_START: u64 = 30000;
    const ADMIN_TYPE_ALLOWLIST_ENABLE: u64 = 30000;
    const ADMIN_TYPE_ALLOWLIST_COIN_UPDATE: u64 = 30001;
    const ADMIN_TYPE_ALLOWLIST_OBJECT_UPDATE: u64 = 30002;
    const ADMIN_TYPE_ALLOWLIST_DEFAULT_UPDATE: u64 = 30003;
    const ADMIN_TYPE_ALLOWLIST_COIN_DELETE: u64 = 30004;
    const ADMIN_TYPE_ALLOWLIST_OBJECT_DELETE: u64 = 30005;
    const ADMIN_TYPE_ALLOWLIST_RANGE_END: u64 = 40000 - 1;

    /// spending limit start from 40000
    const ADMIN_TYPE_SPENDING_LIMIT_RANGE_START: u64 = 40000;
    const ADMIN_TYPE_CREATE_SPENDING_LIMIT: u64 = 40000;
    const ADMIN_TYPE_DELETE_SPENDING_LIMIT: u64 = 40001;
    const ADMIN_TYPE_SPENDING_LIMIT_RANGE_END: u64 = 50000 - 1;

    /// spending limit Maven Change start from 50000
    const ADMIN_TYPE_META_INFO_RANGE_START: u64 = 50000;
    const ADMIN_TYPE_UPDATE_META_INFO: u64 = 50000;
    const ADMIN_TYPE_META_INFO_RANGE_END: u64 = 60000 - 1;


    /* ===================== RoleBook Operation ===================== */
    struct CreateRole {
        name: String,
    }

    public fun deserialize_create_role(bytes: vector<u8>): CreateRole {
        let deserializer = bcs::new(bytes);
        let name = bcs::peel_vec_u8(&mut deserializer);
        let remainder = bcs::into_remainder_bytes(deserializer);
        assert!(vector::length(&remainder) == 0, E_HAS_REDUNDANT_DATA);

        let create_role = CreateRole {
            name: ascii::string(name),
        };
        create_role
    }

    public fun create_role_destruct(op_spec: CreateRole): String {
        let CreateRole { name } = op_spec;
        name
    }

    struct CreateSigner {
        address: address,
    }

    /// deserialize CreateSigner
    public fun deserialize_create_signer(bytes: vector<u8>): CreateSigner {
        let deserializer = bcs::new(bytes);
        let address = bcs::peel_address(&mut deserializer);
        let remainder = bcs::into_remainder_bytes(deserializer);
        assert!(vector::length(&remainder) == 0, E_HAS_REDUNDANT_DATA);

        CreateSigner {
            address,
        }
    }

    public fun create_signer_destruct(op_spec: CreateSigner): address {
        let CreateSigner { address } = op_spec;
        address
    }

    struct GrantRole {
        role_id: QueryID<RoleID>,
        address: address,
    }

    /// deserialize GrantRole
    public fun deserialize_grant_role(bytes: vector<u8>): GrantRole {
        let deserializer = bcs::new(bytes);
        let role_id = id::deserialize_role_query_id(&mut deserializer);
        let address = bcs::peel_address(&mut deserializer);
        let remainder = bcs::into_remainder_bytes(deserializer);
        assert!(vector::length(&remainder) == 0, E_HAS_REDUNDANT_DATA);

        GrantRole {
            role_id,
            address,
        }
    }

    public fun grant_role_destruct(op_spec: GrantRole): (QueryID<RoleID>, address) {
        let GrantRole { role_id, address } = op_spec;
        (role_id, address)
    }

    struct RevokeRole {
        role_id: QueryID<RoleID>,
        address: address,
    }

    /// deserialize RevokeRole
    public fun deserialize_revoke_role(bytes: vector<u8>): RevokeRole {
        let deserializer = bcs::new(bytes);
        let role_id = id::deserialize_role_query_id(&mut deserializer);
        let address = bcs::peel_address(&mut deserializer);
        let remainder = bcs::into_remainder_bytes(deserializer);
        assert!(vector::length(&remainder) == 0, E_HAS_REDUNDANT_DATA);

        RevokeRole {
            role_id,
            address,
        }
    }

    public fun revoke_role_destruct(op_spec: RevokeRole): (QueryID<RoleID>, address) {
        let RevokeRole { role_id, address } = op_spec;
        (role_id, address)
    }

    struct DeleteRole {
        role_id: QueryID<RoleID>,
    }

    /// deserialize DeleteRole
    public fun deserialize_delete_role(bytes: vector<u8>): DeleteRole {
        let deserializer = bcs::new(bytes);
        let role_id = id::deserialize_role_query_id(&mut deserializer);
        let remainder = bcs::into_remainder_bytes(deserializer);
        assert!(vector::length(&remainder) == 0, E_HAS_REDUNDANT_DATA);

        DeleteRole {
            role_id,
        }
    }

    public fun delete_role_destruct(op_spec: DeleteRole): QueryID<RoleID> {
        let DeleteRole { role_id } = op_spec;
        role_id
    }

    struct DeleteSigner {
        address: address,
    }

    /// deserialize DeleteSigner
    public fun deserialize_delete_signer(bytes: vector<u8>): DeleteSigner {
        let deserializer = bcs::new(bytes);
        let address = bcs::peel_address(&mut deserializer);
        let remainder = bcs::into_remainder_bytes(deserializer);
        assert!(vector::length(&remainder) == 0, E_HAS_REDUNDANT_DATA);

        DeleteSigner {
            address,
        }
    }

    public fun delete_signer_destruct(op_spec: DeleteSigner): address {
        let DeleteSigner { address } = op_spec;
        address
    }

    struct RenameRole {
        role_id: QueryID<RoleID>,
        name: String,
    }

    /// deserialize RenameRole
    public fun deserialize_rename_role(bytes: vector<u8>): RenameRole {
        let deserializer = bcs::new(bytes);
        let role_id = id::deserialize_role_query_id(&mut deserializer);
        let name = bcs::peel_vec_u8(&mut deserializer);
        let remainder = bcs::into_remainder_bytes(deserializer);
        assert!(vector::length(&remainder) == 0, E_HAS_REDUNDANT_DATA);

        RenameRole {
            role_id,
            name: ascii::string(name),
        }
    }

    public fun rename_role_destruct(op_spec: RenameRole): (QueryID<RoleID>, String) {
        let RenameRole { role_id, name } = op_spec;
        (role_id, name)
    }

    /* ===================== PermissionBook Permission Operation ===================== */
    /// we can't reference struct definition in permission module, because it will cause a cycle dependency
    /// we may refactor this later
    struct CreatePermission {
        name: String,
        threshold: u64,
        proposer: QueryID<RoleID>,
        approver: QueryID<RoleID>
    }

    /// deserialize CreatePermission
    public fun deserialize_create_permission(bytes: vector<u8>): CreatePermission {
        let deserializer = bcs::new(bytes);
        let name = bcs::peel_vec_u8(&mut deserializer);
        let threshold = bcs::peel_u64(&mut deserializer);
        let proposer = id::deserialize_role_query_id(&mut deserializer);
        let approver = id::deserialize_role_query_id(&mut deserializer);
        let remainder = bcs::into_remainder_bytes(deserializer);
        assert!(vector::length(&remainder) == 0, E_HAS_REDUNDANT_DATA);

        CreatePermission {
            name: ascii::string(name),
            threshold,
            proposer,
            approver,
        }
    }

    public fun create_permission_destruct(op_spec: CreatePermission): (String, u64, QueryID<RoleID>, QueryID<RoleID>) {
        let CreatePermission { name, threshold, proposer, approver } = op_spec;
        (name, threshold, proposer, approver)
    }

    struct UpdatePermission {
        id: QueryID<PermissionID>,
        name: String,
        threshold: u64,
        proposer: QueryID<RoleID>,
        approver: QueryID<RoleID>
    }

    /// deserialize UpdatePermission
    public fun deserialize_update_permission(bytes: vector<u8>): UpdatePermission {
        let deserializer = bcs::new(bytes);
        let id = id::deserialize_permission_query_id(&mut deserializer);
        let name = bcs::peel_vec_u8(&mut deserializer);
        let threshold = bcs::peel_u64(&mut deserializer);
        let proposer = id::deserialize_role_query_id(&mut deserializer);
        let approver = id::deserialize_role_query_id(&mut deserializer);
        let remainder = bcs::into_remainder_bytes(deserializer);
        assert!(vector::length(&remainder) == 0, E_HAS_REDUNDANT_DATA);

        UpdatePermission {
            id,
            name: ascii::string(name),
            threshold,
            proposer,
            approver,
        }
    }

    public fun update_permission_destruct(
        op_spec: UpdatePermission
    ): (QueryID<PermissionID>, String, u64, QueryID<RoleID>, QueryID<RoleID>) {
        let UpdatePermission { id, name, threshold, proposer, approver } = op_spec;
        (id, name, threshold, proposer, approver)
    }

    struct DeletePermission {
        permission_id: QueryID<PermissionID>,
    }

    /// deserialize DeletePermission
    public fun deserialize_delete_permission(bytes: vector<u8>): DeletePermission {
        let deserializer = bcs::new(bytes);
        let permission_id = id::deserialize_permission_query_id(&mut deserializer);
        let remainder = bcs::into_remainder_bytes(deserializer);
        assert!(vector::length(&remainder) == 0, E_HAS_REDUNDANT_DATA);

        DeletePermission {
            permission_id,
        }
    }

    /// destruct DeletePermission
    public fun delete_permission_destruct(op_spec: DeletePermission): QueryID<PermissionID> {
        let DeletePermission { permission_id } = op_spec;
        permission_id
    }


    /* ===================== PermissionBook Policy Operation ===================== */
    struct UpdateAdminPolicy {
        operation_type: String,
        permission_id: QueryID<PermissionID>,
    }

    /// deserialize UpdateAdminPolicy
    public fun deserialize_update_admin_policy(bytes: vector<u8>): UpdateAdminPolicy {
        let deserializer = bcs::new(bytes);
        let operation_type = bcs::peel_vec_u8(&mut deserializer);
        let permission_id = id::deserialize_permission_query_id(&mut deserializer);
        let remainder = bcs::into_remainder_bytes(deserializer);
        assert!(vector::length(&remainder) == 0, E_HAS_REDUNDANT_DATA);

        UpdateAdminPolicy {
            operation_type: ascii::string(operation_type),
            permission_id,
        }
    }

    /// destruct UpdateAdminPolicy
    public fun update_admin_policy_destruct(op_spec: UpdateAdminPolicy): (String, QueryID<PermissionID>) {
        let UpdateAdminPolicy { operation_type, permission_id } = op_spec;
        (operation_type, permission_id)
    }

    struct UpdateCoinPolicy {
        coin_type: String,
        stages: vector<u64>,
        permission_ids: vector<QueryID<PermissionID>>,
    }

    /// deserialize UpdateCoinPolicy
    public fun deserialize_update_coin_policy(bytes: vector<u8>): UpdateCoinPolicy {
        let deserializer = bcs::new(bytes);
        let coin_type = bcs::peel_vec_u8(&mut deserializer);
        let stages = bcs::peel_vec_u64(&mut deserializer);
        let permission_ids = id::deserialize_vec_permission_query_id(&mut deserializer);
        let remainder = bcs::into_remainder_bytes(deserializer);
        assert!(vector::length(&remainder) == 0, E_HAS_REDUNDANT_DATA);

        UpdateCoinPolicy {
            coin_type: ascii::string(coin_type),
            stages,
            permission_ids,
        }
    }

    /// destruct UpdateCoinPolicy
    public fun update_coin_policy_destruct(
        op_spec: UpdateCoinPolicy
    ): (String, vector<u64>, vector<QueryID<PermissionID>>) {
        let UpdateCoinPolicy { coin_type, stages, permission_ids } = op_spec;
        (coin_type, stages, permission_ids)
    }

    struct UpdateObjectPolicy {
        object_id: ID,
        permission_id: QueryID<PermissionID>,
    }

    /// deserialize UpdateObjectPolicy
    public fun deserialize_update_object_policy(bytes: vector<u8>): UpdateObjectPolicy {
        let deserializer = bcs::new(bytes);
        let object_id = bcs::peel_address(&mut deserializer);
        let permission_id = id::deserialize_permission_query_id(&mut deserializer);
        let remainder = bcs::into_remainder_bytes(deserializer);
        assert!(vector::length(&remainder) == 0, E_HAS_REDUNDANT_DATA);

        UpdateObjectPolicy {
            object_id: object::id_from_address(object_id),
            permission_id,
        }
    }

    /// destruct UpdateObjectPolicy
    public fun update_object_policy_destruct(op_spec: UpdateObjectPolicy): (ID, QueryID<PermissionID>) {
        let UpdateObjectPolicy { object_id, permission_id } = op_spec;
        (object_id, permission_id)
    }

    struct UpdateRecoveryPolicy {
        permission_id: QueryID<PermissionID>,
        timelock_duration: u64,
        execution_duration: u64,
    }

    /// deserialize UpdateRecoveryPolicy
    public fun deserialize_update_recovery_policy(bytes: vector<u8>): UpdateRecoveryPolicy {
        let deserializer = bcs::new(bytes);
        let permission_id = id::deserialize_permission_query_id(&mut deserializer);
        let timelock_duration = bcs::peel_u64(&mut deserializer);
        let execution_duration = bcs::peel_u64(&mut deserializer);
        let remainder = bcs::into_remainder_bytes(deserializer);
        assert!(vector::length(&remainder) == 0, E_HAS_REDUNDANT_DATA);

        UpdateRecoveryPolicy {
            permission_id,
            timelock_duration,
            execution_duration,
        }
    }

    /// destruct UpdateRecoveryPolicy
    public fun update_recovery_policy_destruct(
        op_spec: UpdateRecoveryPolicy
    ): (QueryID<PermissionID>, u64, u64) {
        let UpdateRecoveryPolicy { permission_id, timelock_duration, execution_duration } = op_spec;
        (permission_id, timelock_duration, execution_duration)
    }

    struct DeleteAdminPolicy {
        operation_type: String,
    }

    /// deserialize DeleteAdminPolicy
    public fun deserialize_delete_admin_policy(bytes: vector<u8>): DeleteAdminPolicy {
        let deserializer = bcs::new(bytes);
        let operation_type = bcs::peel_vec_u8(&mut deserializer);
        let remainder = bcs::into_remainder_bytes(deserializer);
        assert!(vector::length(&remainder) == 0, E_HAS_REDUNDANT_DATA);

        DeleteAdminPolicy {
            operation_type: ascii::string(operation_type),
        }
    }

    /// destruct DeleteAdminPolicy
    public fun delete_admin_policy_destruct(op_spec: DeleteAdminPolicy): String {
        let DeleteAdminPolicy { operation_type } = op_spec;
        operation_type
    }

    struct DeleteCoinPolicy {
        coin_type: String,
    }

    /// deserialize DeleteCoinPolicy
    public fun deserialize_delete_coin_policy(bytes: vector<u8>): DeleteCoinPolicy {
        let deserializer = bcs::new(bytes);
        let coin_type = bcs::peel_vec_u8(&mut deserializer);
        let remainder = bcs::into_remainder_bytes(deserializer);
        assert!(vector::length(&remainder) == 0, E_HAS_REDUNDANT_DATA);

        DeleteCoinPolicy {
            coin_type: ascii::string(coin_type),
        }
    }

    /// destruct DeleteCoinPolicy
    public fun delete_coin_policy_destruct(op_spec: DeleteCoinPolicy): String {
        let DeleteCoinPolicy { coin_type } = op_spec;
        coin_type
    }

    struct DeleteObjectPolicy {
        object_id: ID,
    }

    /// deserialize DeleteObjectPolicy
    public fun deserialize_delete_object_policy(bytes: vector<u8>): DeleteObjectPolicy {
        let deserializer = bcs::new(bytes);
        let object_id = bcs::peel_address(&mut deserializer);
        let remainder = bcs::into_remainder_bytes(deserializer);
        assert!(vector::length(&remainder) == 0, E_HAS_REDUNDANT_DATA);

        DeleteObjectPolicy {
            object_id: object::id_from_address(object_id),
        }
    }

    /// destruct DeleteObjectPolicy
    public fun delete_object_policy_destruct(op_spec: DeleteObjectPolicy): ID {
        let DeleteObjectPolicy { object_id } = op_spec;
        object_id
    }

    struct DeleteRecoveryPolicy {}

    /// deserialize DeleteRecoveryPolicy
    public fun deserialize_delete_recovery_policy(bytes: vector<u8>): DeleteRecoveryPolicy {
        assert!(vector::length(&bytes) == 0, E_HAS_REDUNDANT_DATA);
        DeleteRecoveryPolicy {}
    }

    /// destruct DeleteRecoveryPolicy
    public fun delete_recovery_policy_destruct(op_spec: DeleteRecoveryPolicy) {
        let DeleteRecoveryPolicy {} = op_spec;
    }

    /* ===================== Allowlist Operation  ===================== */
    struct AllowlistEnable {
        enable: bool,
    }

    /// deserialize EnableAllowlist
    public fun deserialize_allowlist_enable(bytes: vector<u8>): AllowlistEnable {
        let deserializer = bcs::new(bytes);
        let enable = bcs::peel_bool(&mut deserializer);
        let remainder = bcs::into_remainder_bytes(deserializer);
        assert!(vector::length(&remainder) == 0, E_HAS_REDUNDANT_DATA);

        AllowlistEnable {
            enable,
        }
    }

    /// destruct EnableAllowlist
    public fun allowlist_enable_destruct(op_spec: AllowlistEnable): bool {
        let AllowlistEnable { enable } = op_spec;
        enable
    }

    struct AllowlistCoinUpdate {
        coin_type: String,
        addresses: vector<address>,
    }

    /// deserialize AllowlistCoinUpdate
    public fun deserialize_allowlist_coin_update(bytes: vector<u8>): AllowlistCoinUpdate {
        let deserializer = bcs::new(bytes);
        let coin = bcs::peel_vec_u8(&mut deserializer);
        let addresses = bcs::peel_vec_address(&mut deserializer);
        let remainder = bcs::into_remainder_bytes(deserializer);
        assert!(vector::length(&remainder) == 0, E_HAS_REDUNDANT_DATA);

        AllowlistCoinUpdate {
            coin_type: ascii::string(coin),
            addresses,
        }
    }


    /// destruct AllowlistCoinUpdate
    public fun allowlist_coin_update_destruct(op_spec: AllowlistCoinUpdate): (String, vector<address>) {
        let AllowlistCoinUpdate { coin_type, addresses } = op_spec;
        (coin_type, addresses)
    }

    struct AllowlistObjectUpdate {
        object_id: ID,
        addresses: vector<address>,
    }

    /// deserialize AllowlistObjectUpdate
    public fun deserialize_allowlist_object_update(bytes: vector<u8>): AllowlistObjectUpdate {
        let deserializer = bcs::new(bytes);
        let object_id = bcs::peel_address(&mut deserializer);
        let addresses = bcs::peel_vec_address(&mut deserializer);
        let remainder = bcs::into_remainder_bytes(deserializer);
        assert!(vector::length(&remainder) == 0, E_HAS_REDUNDANT_DATA);

        AllowlistObjectUpdate {
            object_id: object::id_from_address(object_id),
            addresses,
        }
    }

    /// destruct AllowlistObjectUpdate
    public fun allowlist_object_update_destruct(op_spec: AllowlistObjectUpdate): (ID, vector<address>) {
        let AllowlistObjectUpdate { object_id, addresses } = op_spec;
        (object_id, addresses)
    }

    struct AllowlistDefaultUpdate {
        addresses: vector<address>,
    }

    /// deserialize AllowlistDefaultUpdate
    public fun deserialize_allowlist_default_update(bytes: vector<u8>): AllowlistDefaultUpdate {
        let deserializer = bcs::new(bytes);
        let addresses = bcs::peel_vec_address(&mut deserializer);
        let remainder = bcs::into_remainder_bytes(deserializer);
        assert!(vector::length(&remainder) == 0, E_HAS_REDUNDANT_DATA);

        AllowlistDefaultUpdate {
            addresses,
        }
    }

    /// destruct AllowlistDefaultUpdate
    public fun allowlist_default_update_destruct(op_spec: AllowlistDefaultUpdate): vector<address> {
        let AllowlistDefaultUpdate { addresses } = op_spec;
        addresses
    }

    struct AllowlistCoinDelete {
        coin_type: String,
    }

    /// deserialize AllowlistCoinDelete
    public fun deserialize_allowlist_coin_delete(bytes: vector<u8>): AllowlistCoinDelete {
        let deserializer = bcs::new(bytes);
        let coin = bcs::peel_vec_u8(&mut deserializer);
        let remainder = bcs::into_remainder_bytes(deserializer);
        assert!(vector::length(&remainder) == 0, E_HAS_REDUNDANT_DATA);

        AllowlistCoinDelete {
            coin_type: ascii::string(coin),
        }
    }

    /// destruct AllowlistCoinDelete
    public fun allowlist_coin_delete_destruct(op_spec: AllowlistCoinDelete): String {
        let AllowlistCoinDelete { coin_type } = op_spec;
        coin_type
    }

    struct AllowlistObjectDelete {
        object_id: ID,
    }

    /// deserialize AllowlistObjectDelete
    public fun deserialize_allowlist_object_delete(bytes: vector<u8>): AllowlistObjectDelete {
        let deserializer = bcs::new(bytes);
        let object_id = bcs::peel_address(&mut deserializer);
        let remainder = bcs::into_remainder_bytes(deserializer);
        assert!(vector::length(&remainder) == 0, E_HAS_REDUNDANT_DATA);

        AllowlistObjectDelete {
            object_id: object::id_from_address(object_id),
        }
    }

    /// destruct AllowlistObjectDelete
    public fun allowlist_object_delete_destruct(op_spec: AllowlistObjectDelete): ID {
        let AllowlistObjectDelete { object_id } = op_spec;
        object_id
    }

    /* ===================== Spneding limit Operation  ===================== */
    struct CreateSpendingLimit {
        spender: address,
        coin_type: String,
        start_time_ms: u64,
        period_ms: u64,
        limit: u64,
    }

    /// deserialize CreateSpendingLimit
    public fun deserialize_create_spending_limit(bytes: vector<u8>): CreateSpendingLimit {
        let deserializer = bcs::new(bytes);
        let spender = bcs::peel_address(&mut deserializer);
        let coin = bcs::peel_vec_u8(&mut deserializer);
        let start_time_ms = bcs::peel_u64(&mut deserializer);
        let period_ms = bcs::peel_u64(&mut deserializer);
        let limit = bcs::peel_u64(&mut deserializer);
        let remainder = bcs::into_remainder_bytes(deserializer);
        assert!(vector::length(&remainder) == 0, E_HAS_REDUNDANT_DATA);

        CreateSpendingLimit {
            spender,
            coin_type: ascii::string(coin),
            start_time_ms,
            period_ms,
            limit,
        }
    }

    /// destruct CreateSpendingLimit
    public fun create_spending_limit_destruct(op_spec: CreateSpendingLimit): (address, String, u64, u64, u64) {
        let CreateSpendingLimit { spender, coin_type, start_time_ms, period_ms, limit } = op_spec;
        (spender, coin_type, start_time_ms, period_ms, limit)
    }

    struct DeleteSpendingLimit {
        spender: address,
        coin_type: String,
        spending_limit_id: u64,
    }

    /// deserialize DeleteSpendingLimit
    public fun deserialize_delete_spending_limit(bytes: vector<u8>): DeleteSpendingLimit {
        let deserializer = bcs::new(bytes);
        let spender = bcs::peel_address(&mut deserializer);
        let coin = bcs::peel_vec_u8(&mut deserializer);
        let spending_limit_id = bcs::peel_u64(&mut deserializer);
        let remainder = bcs::into_remainder_bytes(deserializer);
        assert!(vector::length(&remainder) == 0, E_HAS_REDUNDANT_DATA);

        DeleteSpendingLimit {
            spender,
            coin_type: ascii::string(coin),
            spending_limit_id,
        }
    }

    /// destruct DeleteSpendingLimit
    public fun delete_spending_limit_destruct(op_spec: DeleteSpendingLimit): (address, String, u64) {
        let DeleteSpendingLimit { spender, coin_type, spending_limit_id } = op_spec;
        (spender, coin_type, spending_limit_id)
    }


    /* ===================== Meta Info Operation  ===================== */
    struct UpdateMetaInfo {
        name: String,
        uri: String,
    }

    /// deserialize UpdateMetaInfo
    public fun deserialize_update_meta_info(bytes: vector<u8>): UpdateMetaInfo {
        let deserializer = bcs::new(bytes);
        let name = bcs::peel_vec_u8(&mut deserializer);
        let uri = bcs::peel_vec_u8(&mut deserializer);
        let remainder = bcs::into_remainder_bytes(deserializer);
        assert!(vector::length(&remainder) == 0, E_HAS_REDUNDANT_DATA);

        UpdateMetaInfo {
            name: ascii::string(name),
            uri: ascii::string(uri),
        }
    }

    /// destruct UpdateMetaInfo
    public fun update_meta_info_destruct(op_spec: UpdateMetaInfo): (String, String) {
        let UpdateMetaInfo { name, uri } = op_spec;
        (name, uri)
    }


    /* ===================== help functions  ===================== */

    /// role book range
    public fun is_role_range_operation(admin_type: u64): bool {
        admin_type >= ADMIN_TYPE_ROLE_RANGE_START && admin_type <= ADMIN_TYPE_ROLE_RANGE_END
    }

    public fun is_op_create_role(admin_type: u64): bool {
        admin_type == ADMIN_TYPE_CREATE_ROLE
    }

    public fun is_op_create_signer(admin_type: u64): bool {
        admin_type == ADMIN_TYPE_CREATE_SIGNER
    }

    public fun is_op_grant_role(admin_type: u64): bool {
        admin_type == ADMIN_TYPE_GRANT_ROLE
    }

    public fun is_op_revoke_role(admin_type: u64): bool {
        admin_type == ADMIN_TYPE_REVOKE_ROLE
    }

    public fun is_op_delete_role(admin_type: u64): bool {
        admin_type == ADMIN_TYPE_DELETE_ROLE
    }

    public fun is_op_delete_signer(admin_type: u64): bool {
        admin_type == ADMIN_TYPE_DELETE_SIGNER
    }

    public fun is_op_rename_role(admin_type: u64): bool {
        admin_type == ADMIN_TYPE_RENAME_ROLE
    }

    /// permission book permission range
    public fun is_permission_range_operation(admin_type: u64): bool {
        admin_type >= ADMIN_TYPE_PERMISSION_RANGE_START && admin_type <= ADMIN_TYPE_PERMISSION_RANGE_END
    }

    public fun is_op_create_permission(admin_type: u64): bool {
        admin_type == ADMIN_TYPE_CREATE_PERMISSION
    }

    public fun is_op_update_permission(admin_type: u64): bool {
        admin_type == ADMIN_TYPE_UPDATE_PERMISSION
    }

    public fun is_op_delete_permission(admin_type: u64): bool {
        admin_type == ADMIN_TYPE_DELETE_PERMISSION
    }

    /// permission book policy range
    public fun is_policy_range_operation(admin_type: u64): bool {
        admin_type >= ADMIN_TYPE_POLICY_RANGE_START && admin_type <= ADMIN_TYPE_POLICY_RANGE_END
    }

    public fun is_op_update_admin_policy(admin_type: u64): bool {
        admin_type == ADMIN_TYPE_UPDATE_ADMIN_POLICY
    }

    public fun is_op_update_coin_policy(admin_type: u64): bool {
        admin_type == ADMIN_TYPE_UPDATE_COIN_POLICY
    }

    public fun is_op_update_object_policy(admin_type: u64): bool {
        admin_type == ADMIN_TYPE_UPDATE_OBJECT_POLICY
    }

    public fun is_op_update_recovery_policy(admin_type: u64): bool {
        admin_type == ADMIN_TYPE_UPDATE_RECOVERY_POLICY
    }

    public fun is_op_delete_admin_policy(admin_type: u64): bool {
        admin_type == ADMIN_TYPE_DELETE_ADMIN_POLICY
    }

    public fun is_op_delete_coin_policy(admin_type: u64): bool {
        admin_type == ADMIN_TYPE_DELETE_COIN_POLICY
    }

    public fun is_op_delete_object_policy(admin_type: u64): bool {
        admin_type == ADMIN_TYPE_DELETE_OBJECT_POLICY
    }

    public fun is_op_delete_recovery_policy(admin_type: u64): bool {
        admin_type == ADMIN_TYPE_DELETE_RECOVERY_POLICY
    }

    /// allowlist range
    public fun is_allowlist_range_operation(admin_type: u64): bool {
        admin_type >= ADMIN_TYPE_ALLOWLIST_RANGE_START && admin_type <= ADMIN_TYPE_ALLOWLIST_RANGE_END
    }

    public fun is_op_allowlist_enable(admin_type: u64): bool {
        admin_type == ADMIN_TYPE_ALLOWLIST_ENABLE
    }

    public fun is_op_allowlist_coin_update(admin_type: u64): bool {
        admin_type == ADMIN_TYPE_ALLOWLIST_COIN_UPDATE
    }

    public fun is_op_allowlist_object_update(admin_type: u64): bool {
        admin_type == ADMIN_TYPE_ALLOWLIST_OBJECT_UPDATE
    }

    public fun is_op_allowlist_default_update(admin_type: u64): bool {
        admin_type == ADMIN_TYPE_ALLOWLIST_DEFAULT_UPDATE
    }

    public fun is_op_allowlist_coin_delete(admin_type: u64): bool {
        admin_type == ADMIN_TYPE_ALLOWLIST_COIN_DELETE
    }

    public fun is_op_allowlist_object_delete(admin_type: u64): bool {
        admin_type == ADMIN_TYPE_ALLOWLIST_OBJECT_DELETE
    }

    /// spending limit range
    public fun is_spending_limit_range_operation(admin_type: u64): bool {
        admin_type >= ADMIN_TYPE_SPENDING_LIMIT_RANGE_START && admin_type <= ADMIN_TYPE_SPENDING_LIMIT_RANGE_END
    }

    public fun is_op_create_spending_limit(admin_type: u64): bool {
        admin_type == ADMIN_TYPE_CREATE_SPENDING_LIMIT
    }

    public fun is_op_delete_spending_limit(admin_type: u64): bool {
        admin_type == ADMIN_TYPE_DELETE_SPENDING_LIMIT
    }

    /// meta info range
    public fun is_meta_info_range_operation(admin_type: u64): bool {
        admin_type >= ADMIN_TYPE_META_INFO_RANGE_START && admin_type <= ADMIN_TYPE_META_INFO_RANGE_END
    }

    public fun is_op_update_meta_info(admin_type: u64): bool {
        admin_type == ADMIN_TYPE_UPDATE_META_INFO
    }
}
