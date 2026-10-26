/*
class MyStatusBar : BaseStatusBar {

    override void Draw (int state) {

        super.Draw(state);

        // Draw sprite in *real screen space*
        DrawTexture(

            TexMan.CheckForTexture("MYBIGSPRITE", TexMan.Type_Any),
            DI_SCREEN_LEFT | DI_SCREEN_BOTTOM, // anchored to bottom-left of screen
            0, 0,
            DI_ITEM_LEFT_TOP | DI_SCREEN_MANUAL, // manual control
            1.0, // alpha
            DI_SCREEN // << THIS makes coordinates real pixels, not 320x200
        );
    }
}
*/