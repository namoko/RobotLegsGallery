package com.alix.command
{
import com.alix.event.ApplicationEvent;
import com.alix.model.ApplicationModel;
import com.alix.model.ApplicationState;
import com.alix.service.IImageLoadService;

import org.robotlegs.mvcs.Command;

public class StartupCommand extends Command
{
    [Inject]
    public var model:ApplicationModel;

    [Inject]
    public var service:IImageLoadService;

    override public function execute():void
    {
        trace("StartupCommand executing");

        model.state = ApplicationState.LOADING_IMAGE_LIST;
        dispatch(new ApplicationEvent(ApplicationEvent.STATE_CHANGED));

        service.loadImageList();
    }
}
}
