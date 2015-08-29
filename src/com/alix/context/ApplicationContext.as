package com.alix.context
{
import com.alix.command.ImagesLoadedCommand;
import com.alix.command.StartupCommand;
import com.alix.event.ApplicationEvent;
import com.alix.event.ImageLoadEvent;
import com.alix.model.ApplicationModel;
import com.alix.service.IImageLoadService;
import com.alix.service.LocalImageLoadService;
import com.alix.view.ApplicationView;
import com.alix.view.ApplicationViewMediator;
import com.alix.view.GalleryView;
import com.alix.view.GalleryViewMediator;
import com.alix.view.StatusView;
import com.alix.view.StatusViewMediator;

import org.robotlegs.mvcs.Context;

public class ApplicationContext extends Context
{
    override public function startup() : void
    {
        trace ("Context startup");

        //init
        mediatorMap.mapView(GalleryView, GalleryViewMediator);
        mediatorMap.mapView(StatusView, StatusViewMediator);
        mediatorMap.mapView(ApplicationView, ApplicationViewMediator);

        injector.mapSingleton(ApplicationModel);
        injector.mapSingletonOf(IImageLoadService, LocalImageLoadService);

        commandMap.mapEvent(ApplicationEvent.START_UP, StartupCommand, ApplicationEvent, true);
        commandMap.mapEvent(ImageLoadEvent.IMAGE_LIST_LOADED, ImagesLoadedCommand, ImageLoadEvent, false);

        //start
        dispatchEvent(new ApplicationEvent(ApplicationEvent.START_UP));
    }
}
}
