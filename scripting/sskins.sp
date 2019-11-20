#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "Tetragromaton/LOTGaming"
#define PLUGIN_VERSION "1.0"

#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <sdkhooks>
#include <smlib>
//#pragma newdecls required
#include <clientprefs>
EngineVersion g_Game;

public Plugin myinfo = 
{
	name = "Special Skins",
	author = PLUGIN_AUTHOR,
	description = "Dress the Skins of the Broken Net Update",
	version = PLUGIN_VERSION,
	url = "tetradev.org"
};
Handle g_sDataSkin;
public void OnPluginStart()
{
	g_Game = GetEngineVersion();
	if(g_Game != Engine_CSGO && g_Game != Engine_CSS)
	{
		SetFailState("This plugin is for CSGO/CSS only.");	
	}
	RegConsoleCmd("skins", SpecialSkin3);
	HookEvent("player_spawn", OnPlayerSpawn);
	g_sDataSkin = RegClientCookie("ss_skin", "", CookieAccess_Private);
}
public IsValidClient(client)
{
	if (!(1 <= client <= MaxClients) || !IsClientInGame(client))
		return false;
	
	return true;
}
public Action OnPlayerSpawn(Event eEvent, const char[] sName, bool bDontBroadcast)
{
	new client = GetClientOfUserId(eEvent.GetInt("userid"));
	if (client)
	{
		if(IsValidClient(client))
		{
			CreateTimer(1.3, ApplySkin, client);
		}
	}
}
public Action ApplySkin(Handle timer, any:client)
{
	char SkinNISMO[255];
	GetClientCookie(client, g_sDataSkin, SkinNISMO, sizeof(SkinNISMO));
	if(!StrEqual(SkinNISMO, ""))
	{
		if (!IsModelPrecached(SkinNISMO))PrecacheModel(SkinNISMO);
		Entity_SetModel(client, SkinNISMO);
	}
}
public Action SpecialSkin3(client,args)
{
	new Handle:menu = CreateMenu(AgencySELECTOR, MenuAction_Select  | MenuAction_End);
	SetMenuTitle(menu, "请选择你的探员等级：");
	AddMenuItem(menu, "Reset", "重置");
	AddMenuItem(menu, "DeservedAGENCY", "杰出级探员");
	AddMenuItem(menu, "NomineeSDX", "特级探员");
	AddMenuItem(menu, "PerfectAGNT", "完美级探员");
	AddMenuItem(menu, "MasterAGENT", "大师级探员");
	DisplayMenu(menu, client, MENU_TIME_FOREVER);	
}
public AgencySELECTOR(Handle:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			//param1 is client, param2 is item

			new String:item[64];
			GetMenuItem(menu, param2, item, sizeof(item));
			
			if (StrEqual(item, "DeservedAGENCY"))
			{
				SelectorMENUGEN(param1, 1);
			}
			else if (StrEqual(item, "NomineeSDX"))
			{
				SelectorMENUGEN(param1, 2);
			}
			else if (StrEqual(item, "PerfectAGNT"))
			{
				SelectorMENUGEN(param1, 3);
			}
			else if (StrEqual(item, "MasterAGENT"))
			{
				SelectorMENUGEN(param1, 4);
			}else if(StrEqual(item, "Reset"))
			{
				SetClientCookie(param1, g_sDataSkin, "");
			}
		}

		case MenuAction_End:
		{
			//param1 is MenuEnd reason, if canceled param2 is MenuCancel reason
			CloseHandle(menu);

		}

	}
}
SelectorMENUGEN(client, int type)
{
	new Handle:menu = CreateMenu(XCGSelector, MenuAction_Select | MenuAction_End);
	SetMenuTitle(menu, "选择你的探员：");
	switch(type)
	{
		case 4://Workshops
		{
			AddMenuItem(menu, "19", "陆军少尉长官Ricksaw | 海军水面战中心海豹部队");
			AddMenuItem(menu, "20", "Ava特工 | 联邦调查局（FBI）");
			AddMenuItem(menu, "21", "“医生”Romanov | Sabre");
			AddMenuItem(menu, "22", "精英Muhlik先生 | 精锐分子");
		}
		case 3://Excellent agents
		{
			AddMenuItem(menu, "14", "Blackwolf | Sabre");
			AddMenuItem(menu, "15", "Michael Syfers | 联邦调查局（FBI）狙击手");
			AddMenuItem(menu, "16", "“两次”McCoy | 美国空军战术空中管制部队");
			AddMenuItem(menu, "17", "Shahmat教授 | 精锐分子");
			AddMenuItem(menu, "18", "准备就绪的Rezan | Sabre");
		}
		case 2://Exceptional Agents
		{
			AddMenuItem(menu, "8", "Markus Delrow | 联邦调查局（FBI）人质营救队");
			AddMenuItem(menu, "9", "Maximus | Sabre");
			AddMenuItem(menu, "10", "铅弹 | 海军水面战中心海豹部队");
			AddMenuItem(menu, "11", "Osiris | 精锐分子");
			AddMenuItem(menu, "12", "弹弓 | 凤凰战士");
			AddMenuItem(menu, "13", "Dragomir | Sabre");
		}
		case 1://Merited Agents
		{
			AddMenuItem(menu, "1", "海豹部队第六分队士兵 | 海军水面战中心海豹部队");
			AddMenuItem(menu, "2", "第三特种兵连 | 德国特种部队突击队");
			AddMenuItem(menu, "3", "特种兵 | 联邦调查局（FBI）特警");
			AddMenuItem(menu, "4", "地面叛军 | 精锐分子");
			AddMenuItem(menu, "5", "执行者 | 凤凰战士");
			AddMenuItem(menu, "6", "枪手 | 凤凰战士");
			AddMenuItem(menu, "7", "C Squadron指挥官 | 英国空军特别部队");
		}
		default:
		{
			//PrintToChat(client, "Not found.");
			CloseHandle(menu);
		}
	}
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}
public XCGSelector(Handle:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			//param1 is client, param2 is item

			new String:item[64];
			GetMenuItem(menu, param2, item, sizeof(item));

			int SPICK = StringToInt(item);
			char ModelName[255];
			if(SPICK > 0)
			{
				switch(SPICK)
				{
					case 6:
					{
						ModelName = "models/player/custom_player/legacy/tm_phoenix_varianth.mdl";
					}
					case 12:
					{
						ModelName = "models/player/custom_player/legacy/tm_phoenix_variantg.mdl";
					}
					case 5:
					{
						ModelName = "models/player/custom_player/legacy/tm_phoenix_variantf.mdl";
					}
					case 17:
					{
						ModelName = "models/player/custom_player/legacy/tm_leet_varianti.mdl";
					}
					case 4:
					{
						ModelName = "models/player/custom_player/legacy/tm_leet_variantg.mdl";
					}
					case 11:
					{
						ModelName = "models/player/custom_player/legacy/tm_leet_varianth.mdl";
					}
					case 14:
					{
						ModelName = "models/player/custom_player/legacy/tm_balkan_variantj.mdl";
					}
					case 9:
					{
						ModelName = "models/player/custom_player/legacy/tm_balkan_varianti.mdl";
					}
					case 21:
					{
						ModelName = "models/player/custom_player/legacy/tm_balkan_varianth.mdl";
					}					
					case 18:
					{
						ModelName = "models/player/custom_player/legacy/tm_balkan_variantg.mdl";
					}
					case 13:
					{ 
						ModelName = "models/player/custom_player/legacy/tm_balkan_variantf.mdl";
					}
					case 16:
					{
						ModelName = "models/player/custom_player/legacy/ctm_st6_variantm.mdl";
					}
					case 19:
					{
						ModelName = "models/player/custom_player/legacy/ctm_st6_varianti.mdl";
					}
					case 10:
					{
						ModelName = "models/player/custom_player/legacy/ctm_st6_variantg.mdl";
					}
					case 7:
					{
						ModelName = "models/player/custom_player/legacy/ctm_sas_variantf.mdl";
					}
					case 15:
					{
						ModelName = "models/player/custom_player/legacy/ctm_fbi_varianth.mdl";
					}
					case 8:
					{
						ModelName = "models/player/custom_player/legacy/ctm_fbi_variantg.mdl";
					}
					case 20:
					{
						ModelName = "models/player/custom_player/legacy/ctm_fbi_variantb.mdl";
					}
					case 22:
					{
						ModelName = "models/player/custom_player/legacy/tm_leet_variantf.mdl";
					}
					case 3:
					{
						ModelName = "models/player/custom_player/legacy/ctm_fbi_variantf.mdl";
					}
					case 1:
					{
						ModelName = "models/player/custom_player/legacy/ctm_st6_variante.mdl";
					}
					case 2:
					{
						ModelName = "models/player/custom_player/legacy/ctm_st6_variantk.mdl";
					}
				}
				//PrintToChatAll("%s", ModelName);
				SetClientCookie(param1, g_sDataSkin, ModelName);
				PrintToChat(param1, "您的探员模型将在下次重生应用");
			}
		}


		case MenuAction_End:
		{
			//param1 is MenuEnd reason, if canceled param2 is MenuCancel reason
			CloseHandle(menu);

		}

	}
}
