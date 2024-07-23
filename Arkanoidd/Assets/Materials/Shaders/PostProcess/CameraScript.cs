using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CameraScript : MonoBehaviour
{
    public Shader shader;
    private Material mat;



    // Start is called before the first frame update
    void Start()
    {
        mat = new Material(shader);
    }

    // Update is called once per frame
    void Update()
    {

    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, mat);
    }
}
