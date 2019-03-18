using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraAxisTracking : MonoBehaviour
{
    [SerializeField]
    GameObject player;

    Vector3 oldPos = new Vector3(0, 0, 0);
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        oldPos = transform.position;
        oldPos.x = player.transform.position.x;
        transform.position = oldPos;
    }
}
