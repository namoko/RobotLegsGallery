package com.alix.event
{
import flash.events.Event;

public class ApplicationEvent extends Event
{
    public static const START_UP :String = "START_UP";
    public static const STATE_CHANGED :String = "STATE_CHANGED";

    public function ApplicationEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
    {
        super(type, bubbles, cancelable);
    }
}
}
