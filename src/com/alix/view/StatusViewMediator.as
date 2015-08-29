package com.alix.view
{
import org.robotlegs.mvcs.Mediator;

public class StatusViewMediator extends Mediator
{
    [Inject]
    public var view : StatusView;

    override public function onRegister():void
    {
        trace("StatusViewMediator.onRegister()")
    }
}
}
