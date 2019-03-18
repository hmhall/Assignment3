using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour
{
    [SerializeField]
    Camera camera1, camera2, camera3;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void setActiveCamera(int newCamera)
    {
        switch (newCamera)
        {
            case 1:
                camera1.enabled = true;
                camera2.enabled = false;
                break;
            case 2:
                camera2.enabled = true;
                camera3.enabled = false;
                camera1.enabled = false;
                break;
            case 3:
                camera3.enabled = true;
                camera2.enabled = false;
                break;
        
        }
    }
}
