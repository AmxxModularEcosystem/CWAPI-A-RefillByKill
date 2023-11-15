#include <amxmodx>
#include <reapi>
#include <json>
#include <cwapi>
#include <ParamsController>

enum E_RefillType {
    RefillType_Invalid = -1,

    RefillType_Clip,
    RefillType_BpAmmo,
    RefillType_Both,
}

new const ABILITY_NAME[] = "RefillByKill";
new const PARAM_TYPE_NAME[] = "CWAPI-A-RBK-RefillType";

new const PARAM_BLOCK_TYPE_NAME[] = "RefillType";

new T_WeaponAbility:iAbility = Invalid_WeaponAbility;

public ParamsController_OnRegisterTypes() {
    ParamsController_RegSimpleType(PARAM_TYPE_NAME, "@OnRefillTypeParamRead");
}

public CWAPI_OnLoad() {
    register_plugin("[CWAPI-A] Refill by Kill", "1.0.1", "ArKaNeMaN");

    iAbility = CWAPI_Abilities_Register(ABILITY_NAME);

    CWAPI_Abilities_AddParams(iAbility,
        PARAM_BLOCK_TYPE_NAME, PARAM_TYPE_NAME, true
    );
    CWAPI_Abilities_AddEventListener(iAbility, CWeapon_OnPlayerKilled, "@OnPlayerKilled");
}

@OnPlayerKilled(const T_CustomWeapon:iWeapon, const ItemId, const VictimId, const KillerId, const Trie:tAbilityParams) {
    new E_BlockType:iRefillType;
    TrieGetCell(tAbilityParams, PARAM_BLOCK_TYPE_NAME, iRefillType);

    switch (iRefillType) {
        case RefillType_Clip: {
            InstantReloadWeapon(ItemId);
        }
        case RefillType_BpAmmo: {
            FillBpAmmoByItem(KillerId, ItemId);
        }
        case RefillType_Both: {
            InstantReloadWeapon(ItemId);
            FillBpAmmoByItem(KillerId, ItemId);
        }
    }
}

bool:@OnRefillTypeParamRead(const JSON:jValue) {
    new sRefillType[16];
    json_get_string(jValue, sRefillType, charsmax(sRefillType));

    new E_RefillType:iRefillType = StrToRefillType(sRefillType);
    if (iRefillType == RefillType_Invalid) {
        return false;
    }

    return ParamsController_SetCell(iRefillType);
}

E_RefillType:StrToRefillType(const sRefillType[]) {
    if (equali(sRefillType, "Default")) {
        return RefillType_Clip;
    } else if (equali(sRefillType, "Drop")) {
        return RefillType_BpAmmo;
    } else if (equali(sRefillType, "Remove")) {
        return RefillType_Both;
    }

    return RefillType_Clip;
    // return RefillType_Invalid;
}

InstantReloadWeapon(const ItemId) {
    if (!is_nullent(ItemId) && ItemHasClip(ItemId)) {
        set_member(ItemId, m_Weapon_iClip, rg_get_iteminfo(ItemId, ItemInfo_iMaxClip));
    }
}

bool:ItemHasClip(const ItemId) {
    new WeaponIdType:WeaponId = get_member(ItemId, m_iId);
    switch (WeaponId) {
        case WEAPON_KNIFE, WEAPON_HEGRENADE, WEAPON_SMOKEGRENADE, WEAPON_FLASHBANG, WEAPON_SHIELDGUN:
            return false;
        default:
            return true;
    }
    return true;
}

FillBpAmmoByItem(const UserId, const ItemId) {
    new iMaxAmmo = rg_get_iteminfo(ItemId, ItemInfo_iMaxAmmo1);
    new WeaponIdType:WeaponId = WeaponIdType:rg_get_iteminfo(ItemId, ItemInfo_iId);

    if (iMaxAmmo >= 0) {
        rg_set_user_bpammo(UserId, WeaponId, iMaxAmmo);
    }
}
