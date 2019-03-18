using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PlayerController : MonoBehaviour
{
    CharacterController controller;
    float gravity = 20;
    Vector3 movement=Vector3.zero;


    // Start is called before the first frame update
    void Start()
    {
        controller = GetComponent<CharacterController>();
    }

    // Update is called once per frame
    void Update()
    {
        if (controller.isGrounded && Input.GetKeyDown(KeyCode.Space))
        {
            movement.y = 8;
        }
        if (Input.GetKey(KeyCode.LeftArrow))
            transform.Rotate(0, -2, 0);
        if (Input.GetKey(KeyCode.RightArrow))
            transform.Rotate(0, 2, 0);

        if (Input.GetKey(KeyCode.UpArrow))
        {
            movement.x = transform.forward.x * 4;
            movement.z = transform.forward.z * 4;
        }
        else if (Input.GetKey(KeyCode.DownArrow))
        {
            movement.x = transform.forward.x * -4;
            movement.z = transform.forward.z * -4;
        }
        else
        {
            movement.x = 0;
            movement.z = 0;
        }


        movement.y -= gravity*Time.deltaTime;
        controller.Move(movement*Time.deltaTime);
    }
 
}
