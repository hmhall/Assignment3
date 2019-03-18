using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Room1Trigger : MonoBehaviour
{
    [SerializeField]
    GameObject cameraController;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    private void OnTriggerEnter(Collider other)
    {
        if (other.tag.Equals("Player"))
            cameraController.GetComponent<CameraController>().setActiveCamera(1);
    }
}
