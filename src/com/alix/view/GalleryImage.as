package com.alix.view
{
import com.alix.event.ImageLoadEvent;
import com.greensock.TweenLite;

import flash.display.Bitmap;

import flash.display.Loader;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLRequest;

import mx.core.UIComponent;

public class GalleryImage extends UIComponent implements IGalleryImage
{
    private static const TWEEN_TIME:Number = .3;

    private const DEFAULT_WIDTH : int = 100;
    private const DEFAULT_HEIGHT : int = 200;

    public var originalWidth : int;
    public var originalHeight : int;

    private var loader : Loader;
    private var hasError : Boolean;

    private var moveTweener:TweenLite;
    private var showTweener:TweenLite;
    private var hideTweener:TweenLite;

    public function GalleryImage()
    {
        originalWidth = width = DEFAULT_WIDTH;
        originalHeight = height = DEFAULT_HEIGHT;
    }

    public function hide():void
    {
        if (hideTweener != null) return; // already tweening hide

        hideTweener = TweenLite.to(this, TWEEN_TIME, {alpha:0, onComplete : hideComplete});
    }
    private function hideComplete():void
    {
        dispatchEvent(new ImageLoadEvent(ImageLoadEvent.IMAGE_HIDDEN));
    }

    public function dispose():void
    {
        if (loader == null) return;

        var bitmap : Bitmap = loader.content as Bitmap;
        if (bitmap == null) return;

        bitmap.bitmapData.dispose();
    }

    public function set source(url:String) : void
    {
        if (loader != null)
        {
            loader.close();
        }

        if (url == null || url.length == 0) return;

        var request : URLRequest = new URLRequest(url);

        loader = new Loader();
        loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadComplete);
        loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);

        loader.load(request);
        addChild(loader);

        alpha = 0;
        hasError = false;
        super.invalidateDisplayList();
    }

    private function onLoadComplete(e:Event):void
    {
        if (loader.content == null) return;

        var bitmap:Bitmap = loader.content as Bitmap;
        if (bitmap == null) return;

        bitmap.smoothing = true;
        originalWidth = width = bitmap.bitmapData.width;
        originalHeight = height = bitmap.bitmapData.height;

        dispatchEvent(new ImageLoadEvent(ImageLoadEvent.IMAGE_LOAD_COMPLETE));

        if (showTweener) showTweener.kill();
        showTweener = TweenLite.to(this, TWEEN_TIME, {alpha:1});
    }

    private function onLoadError(e:Event):void
    {
        trace ("GalleryImage.onLoadError", e);

        hasError = true;
        invalidateDisplayList();

        if (showTweener) showTweener.kill();
        showTweener = TweenLite.to(this, TWEEN_TIME, {alpha:1});
    }

    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);

        graphics.clear();

        if (!hasError) return;

        graphics.lineStyle(2, 0xFF0000);
        graphics.beginFill(0xFFFFFF, 1);
        graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);

        graphics.endFill();

        graphics.moveTo(0, 0);
        graphics.lineTo(unscaledWidth, unscaledHeight);
        graphics.moveTo(unscaledWidth, 0);
        graphics.lineTo(0, unscaledHeight);
        graphics.drawRect(0,0, unscaledWidth, unscaledHeight);
    }

    public function calculateRelativeWidth(height:Number): Number
    {
        return originalWidth * height / originalHeight;
    }

    public function calculateRelativeHeight(width:Number): Number
    {
        return originalHeight * width / originalWidth;
    }

    override public function set width(value:Number):void
    {
        super.width = value;

        if (loader == null) return;

        loader.width = value;
    }

    override public function set height(value:Number):void
    {
        super.height = value;

        if (loader == null) return;

        loader.height = value;
    }


    public function moveAndResizeHeight(x:Number, y:Number, height:Number):void
    {
        var width = calculateRelativeWidth(height);

        moveAndResize(x, y, width, height);
    }
    public function moveAndResizeWidth(x:Number, y:Number, width:Number):void
    {
        var height = calculateRelativeHeight(width);

        moveAndResize(x, y, width, height);
    }

    public function moveAndResize(x:Number, y:Number, width:Number, height : Number)
    {
        if (moveTweener != null) moveTweener.kill();
        moveTweener = TweenLite.to(this, TWEEN_TIME, {x:x, y:y, width:width, height:height});
    }
}
}
