package com.alix.command
{
import com.alix.event.ApplicationEvent;
import com.alix.model.ApplicationModel;
import com.alix.model.ApplicationState;

import org.robotlegs.mvcs.Command;

public class ImagesLoadedCommand extends Command
{
    [Inject]
    public var model : ApplicationModel;

    override public function execute():void
    {
       //trace("images loaded");

        model.state = ApplicationState.GALLERY;
        dispatch(new ApplicationEvent(ApplicationEvent.STATE_CHANGED));
    }
}
}
