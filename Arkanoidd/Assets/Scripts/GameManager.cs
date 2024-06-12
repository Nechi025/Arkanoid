using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameManager : MonoBehaviour
{
    public HUD _hud;
    public Bola ballPrefab;

    private int bricksLeft;
    private int lifes = 3;

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
        bricksLeft = GameObject.FindGameObjectsWithTag("Brick").Length + GameObject.FindGameObjectsWithTag("BrickMultiball").Length;
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
        SceneManager.LoadScene("MainMenu");
    }

    public void LoseLife()
    {
        if (lifes <= 0)
        {
            SceneManager.LoadScene("MainMenu");
        }

        lifes -= 1;
        _hud.DesactiveLife(lifes);
    }

    public void MultiBall(Vector3 position, int count)
    {
        for (int i = 0; i < count; i++)
        {
            Bola spawnedball = Instantiate(ballPrefab, position + new Vector3(0,0,2), Quaternion.identity) as Bola;

            spawnedball.transform.parent = null;
            spawnedball.velocity.x = Random.Range(-1, 1);
            spawnedball.velocity.z = 1;
            spawnedball.isBallMoving = true;
            Rigidbody spawnedBallRb = spawnedball.GetComponent<Rigidbody>();
            spawnedBallRb.isKinematic = false;
        }
    }


}


