using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HUD : MonoBehaviour
{
    public GameObject[] lifes;

    public void DesactiveLife(int indice)
    {
        lifes[indice].SetActive(false);
    }
}
