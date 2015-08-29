/**
 * Created by Alix on 27.08.2015.
 */
package com.alix.model
{
import org.robotlegs.mvcs.Actor;

public class ApplicationModel extends Actor
{
    public var state:int; // ApplicationState

    // images names stored in server config
    public var imageList : Vector.<String> = new <String>[];
}
}
