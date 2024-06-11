using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameManager : MonoBehaviour
{
    private int bricksLeft;
    private int lifes;

    public static GameManager Instance { get; private set; }

    private void Awake()
    {
        if (Instance != null)
        {
            Destroy(this);
        }
        else Instance = this;
    }

    private void Start()
    {
        bricksLeft = GameObject.FindGameObjectsWithTag("Brick").Length;
    }

    public void BrickDestroy()
    {
        bricksLeft--;
        if (bricksLeft <= 0)
        {
            Win();
        }
    }

    private void Win()
    {
        SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex + 1);
    }

    public void LoseLife()
    {
        if (lifes <= 0)
        {
            SceneManager.LoadScene(0);
        }

        lifes--;
        SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
    }


}


