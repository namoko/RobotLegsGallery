package com.alix.command
{
import com.alix.service.IImageLoadService;

import org.robotlegs.mvcs.Command;

public class LoadImageCommand extends Command
{
    [Inject]
    public var service:IImageLoadService;

    override public function execute():void
    {
        trace("LoadImageCommand executing");

        service.getNextImage();
    }
}
}
