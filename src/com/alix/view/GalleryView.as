/**
 * Created by Alix on 26.08.2015.
 */
package com.alix.view
{
import mx.containers.Canvas;

public class GalleryView extends Canvas
{
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);

        graphics.clear();
        graphics.beginFill(0xFF0000);
        graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
        graphics.endFill();
    }
}
}
