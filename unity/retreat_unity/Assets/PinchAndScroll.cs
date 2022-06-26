using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// reference: https://gist.github.com/ditzel/836bb36d7f70e2aec2dd87ebe1ede432
public class PinchAndScroll : MonoBehaviour
{
    public Camera Camera;
    public bool Rotate;
    protected Plane Plane;

    // Start is called before the first frame update
    void Start()
    {   
        // set camera to main if no other camera is selected
        if (Camera == null)
            Camera = Camera.main;
    }

    // Update is called once per frame
    void Update()
    {
        // Update Plane
        if (Input.touchCount >= 1)
            Plane.SetNormalAndPosition(transform.up, transform.position);

        var Delta1 = Vector3.zero;
        var Delta2 = Vector3.zero;

        // Scroll
        if (Input.touchCount >= 1) 
        {
            Delta1 = PlanePositionDelta(Input.GetTouch(0));
            if (Input.GetTouch(0).phase == TouchPhase.Moved) 
                Camera.transform.Translate(Delta1, Space.World);
            
        }

        // Pinch
        if (Input.touchCount >= 2) 
        {
            var pos1a = PlanePosition(Input.GetTouch(0).position);
            var pos2a = PlanePosition(Input.GetTouch(1).position);
            var pos1b = PlanePosition(Input.GetTouch(0).position - Input.GetTouch(0).deltaPosition);
            var pos2b = PlanePosition(Input.GetTouch(1).position - Input.GetTouch(1).deltaPosition);

            // zoom calculation
            var zoom = Vector3.Distance(pos1a, pos1b) / Vector3.Distance(pos1b, pos2b);

            // edge case
            if (zoom == 0 || zoom > 10) 
                return;
            
            // camera movement 
            Camera.transform.position = Vector3.LerpUnclamped(pos1a, Camera.transform.position, 1 / zoom);

            if (Rotate && pos2b != pos2a)
                Camera.transform.RotateAround(pos1a, Plane.normal, Vector3.SignedAngle(pos2a - pos1a, pos2b - pos1b, Plane.normal));
        }
    }

    // Find the change in position with respect to the plane
    protected Vector3 PlanePositionDelta(Touch touch) 
    {
        // if finger does not move
        if (touch.phase != TouchPhase.Moved) 
        {
            return Vector3.zero;
        }

        // if finger does move, find the difference in position
        var rayPrev = Camera.ScreenPointToRay(touch.position - touch.deltaPosition);
        var rayCurr = Camera.ScreenPointToRay(touch.position);
        if (Plane.Raycast(rayPrev, out float enterPrev) && Plane.Raycast(rayCurr, out float enterCurr))
            return rayPrev.GetPoint(enterPrev) - rayCurr.GetPoint(enterCurr);

        // if finger move out of ground
        return Vector3.zero;
    }

    // Find the position in the plane that correspond to the position in screen
    protected Vector3 PlanePosition(Vector2 screenPos) 
    {   
        // getting the position
        var rayCurr = Camera.ScreenPointToRay(screenPos);
        if (Plane.Raycast(rayCurr, out float enterCurr))
            return rayCurr.GetPoint(enterCurr);
        
        return Vector3.zero;
    }
}
