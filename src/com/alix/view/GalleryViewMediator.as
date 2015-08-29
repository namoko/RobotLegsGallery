package com.alix.view
{
import com.alix.model.ApplicationModel;

import org.robotlegs.mvcs.Mediator;

public class GalleryViewMediator extends Mediator
{

    [Inject]
    public var view : GalleryView;
    [Inject]
    public var model: ApplicationModel;

    override public function onRegister():void
    {
        view.model = model;
    }
}
}
