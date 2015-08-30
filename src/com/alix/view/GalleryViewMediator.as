package com.alix.view
{
import com.alix.event.ImageLoadEvent;
import com.alix.model.ApplicationModel;

import org.robotlegs.mvcs.Mediator;

public class GalleryViewMediator extends Mediator
{
    [Inject]
    public var view : GalleryView;

    [Inject]
    public var model : ApplicationModel;

    override public function onRegister():void
    {
        addViewListener(ImageLoadEvent.LOAD_IMAGE, newImageRequested);

        addContextListener(ImageLoadEvent.IMAGE_LOAD_COMPLETE, newImageLoaded)
    }

    private function newImageRequested(e:ImageLoadEvent):void
    {
        trace("new image requested");
        dispatch(new ImageLoadEvent(ImageLoadEvent.LOAD_IMAGE));
    }

    private function newImageLoaded(e:ImageLoadEvent):void
    {
        trace("new image loaded");

        view.createImage(model.imageUrl);
    }
}
}
