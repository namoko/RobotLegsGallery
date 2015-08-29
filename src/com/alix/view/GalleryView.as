package com.alix.view
{
import com.alix.model.ApplicationModel;

import mx.containers.Canvas;
import mx.controls.Image;

public class GalleryView extends Canvas
{
    public var model:ApplicationModel;

    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);

        graphics.clear();
        graphics.beginFill(0xFF0000);
        graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
        graphics.endFill();
    }

    public function init():void
    {
        trace ("GalleryView.init()");

        while (numChildren > 0) removeChildAt(0);

        var i:int = 0;
        for each (var url in model.imageList)
        {
            var image:Image = new Image();
            image.source = url;

            image.width = 200;
            image.x = 210*i++;
            addChild(image);
        }
    }
}
}
