package com.alix.view
{
import flash.events.IEventDispatcher;

public interface IGalleryImage extends IEventDispatcher
{
    function set source(url:String) : void;
    function calculateRelativeWidth(height:Number): Number;
    function calculateRelativeHeight(width:Number): Number;

    function moveAndResizeHeight(x:Number, y:Number, height:Number):void;
    function moveAndResizeWidth(x:Number, y:Number, width:Number):void;
    function moveAndResize(x:Number, y:Number, width:Number, height : Number);

    function hide():void;
}
}
