package com.alix.view
{
import com.alix.event.ApplicationEvent;
import com.alix.model.ApplicationModel;
import com.alix.model.ApplicationState;

import flash.events.Event;

import mx.events.FlexEvent;

import org.robotlegs.mvcs.Mediator;

public class ApplicationViewMediator extends Mediator
{
    [Inject]
    public var view : ApplicationView;
    [Inject]
    public var model : ApplicationModel;

    override public function onRegister():void
    {
        trace("ApplicationViewMediator.onRegister()");

        view.gallery.visible = false;
        view.status.visible = false;

        eventMap.mapListener(eventDispatcher, ApplicationEvent.STATE_CHANGED, onStateChanged);
        onStateChanged(null);
    }

    private function onStateChanged(e:Event):void
    {
        trace ("ApplicationViewMediator.onStateChanged", model.state);

        switch (model.state)
        {
            case ApplicationState.LOADING_IMAGE_LIST:
                showStatus("Loading image list...");
                break;
            case ApplicationState.GALLERY:
                showGallery();
                break;
            default:
                showStatus("Initializing");
                break;
        }
    }

    public function showStatus(status:String):void
    {
        trace("showStatus()", status);

        view.gallery.visible = false;
        view.status.visible = true;
        view.status.status = status;
    }

    public function showGallery()
    {
        trace("showGallery()");

        view.status.visible = false;

        view.gallery.visible = true;
        view.gallery.createImages(model.imageList);
    }

}
}
