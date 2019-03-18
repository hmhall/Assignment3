using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TimeTravelPostProcessing : MonoBehaviour
{
    public Material timeTravelEffect;
    private float timeStarted = 0f;

    private void OnEnable()
    {
        timeStarted = Time.time;
        //    Debug.Log("TimeTravelPostProcessing script enabled");
        StartCoroutine(Wait());
    }

    private void Update()
    {
        timeTravelEffect.SetFloat("_FadeEffect", Time.time-timeStarted);
        //Debug.Log(timeTravelEffect.GetFloat("_FadeEffect"));
    }

    IEnumerator Wait()
    {
        //This is a coroutine
        yield return new WaitForSeconds(1); ;    //Wait one second
        this.GetComponent<TimeTravelPostProcessing>().enabled = false;
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
            Graphics.Blit(source, destination, timeTravelEffect);
    }


}
