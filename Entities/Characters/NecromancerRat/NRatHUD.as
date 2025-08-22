//builder HUD

#include "Slow.as";
#include "/Entities/Common/GUI/ActorHUDStartPos.as";

const string iconsFilename = "Entities/Characters/Builder/BuilderIcons.png";
const int slotsSize = 6;

void onInit(CSprite@ this)
{
	this.getCurrentScript().runFlags |= Script::tick_myplayer;
	this.getCurrentScript().removeIfTag = "dead";
	this.getBlob().set_u8("gui_HUD_slots_width", slotsSize);
}

void ManageCursors(CBlob@ this)
{
	// set cursor
	if (getHUD().hasButtons())
	{
		getHUD().SetDefaultCursor();
	}
	else
	{
		if (this.isAttached() && this.isAttachedToPoint("GUNNER"))
		{
			getHUD().SetCursorImage("Entities/Characters/Archer/ArcherCursor.png", Vec2f(32, 32));
			getHUD().SetCursorOffset(Vec2f(-32, -32));
		}
		else
		{
			getHUD().SetCursorImage("Entities/Characters/Builder/BuilderCursor.png");
		}

	}
}

void onRender(CSprite@ this)
{
    const u32 gametime = getGameTime();

	CBlob@ blob = this.getBlob();
	ManageCursors(blob);

	if (g_videorecording)
		return;

	CPlayer@ player = blob.getPlayer();

	// draw inventory

	Vec2f tl = getActorHUDStartPosition(blob, slotsSize);
	DrawInventoryOnHUD(blob, tl);

	// draw coins

	const int coins = player !is null ? player.getCoins() : 0;
	DrawCoinsOnHUD(blob, coins, tl, slotsSize - 2);

	// draw class icon

	GUI::DrawIcon(iconsFilename, 3, Vec2f(16, 32), tl + Vec2f(8 + (slotsSize - 1) * 40, -13), 1.0f);

	u32 lastSlow = blob.get_u32("last slow");
	int diff = gametime - (lastSlow + SLOW_FREQUENCY);
	double cooldownSlowSecs = (diff / 30) * (-1);
	int cooldownSlowFullSecs = diff % 30;
	double cooldownSlowSecsHUD;
	if (cooldownSlowFullSecs == 0 && cooldownSlowSecs >= 0) cooldownSlowSecsHUD = cooldownSlowSecs;
	
	u32 lastSummon = blob.get_u32("last summon");
	int difff = gametime - (lastSummon + SUMMON_FREQUENCY);
	double cooldownSummonSecs = (difff / 30) * (-1);
	int cooldownSummonFullSecs = difff % 30;
	double cooldownSummonSecsHUD;
	if (cooldownSummonFullSecs == 0 && cooldownSummonSecs >= 0) cooldownSummonSecsHUD = cooldownSummonSecs;
	
	if (diff > 0)
	{
		GUI::DrawIcon( "Slow.png", 0, Vec2f(16,16), Vec2f(11,158));
		GUI::SetFont("menu"); GUI::DrawText("  R button", Vec2f(25,175), SColor(255, 255, 216, 0));
	}
	else
	{
		GUI::DrawIcon( "MenuItems.png", 13, Vec2f(32,32), Vec2f(10,158), 0.5f);
		GUI::SetFont("menu"); GUI::DrawText("" + cooldownSlowSecs + "  R button", Vec2f(25,175), SColor(255, 255, 216, 0));
	}
	if (difff > 0)
	{
		GUI::DrawIcon( "Summon.png", 0, Vec2f(16,16), Vec2f(11,198));
		GUI::SetFont("menu"); GUI::DrawText("  B button", Vec2f(25,215), SColor(255, 255, 216, 0));
	}
	else
	{
		GUI::DrawIcon( "MenuItems.png", 13, Vec2f(32,32), Vec2f(10,198), 0.5f);
		GUI::SetFont("menu"); GUI::DrawText("" + cooldownSummonSecs + "  B button", Vec2f(25,215), SColor(255, 255, 216, 0));
	}
}
