package com.alix.event
{
import flash.events.Event;

public class ImageLoadEvent extends Event
{
    public static const IMAGE_LIST_ERROR:String = "IMAGE_LIST_ERROR";
    public static const IMAGE_LIST_LOADED:String = "IMAGE_LIST_LOADED";

    public static const IMAGE_LOAD_ERROR:String = "IMAGE_LOAD_ERROR";
    public static const IMAGE_LOAD_COMPLETE:String = "IMAGE_LOAD_COMPLETE";


    public function ImageLoadEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
    {
        super(type, bubbles, cancelable);
    }
}
}
