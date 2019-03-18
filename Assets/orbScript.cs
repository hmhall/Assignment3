using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class orbScript : MonoBehaviour
{
    [SerializeField]
    Camera camera3;
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
            camera3.GetComponent<TimeTravelPostProcessing>().enabled=true;
    }
}
