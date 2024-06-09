using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Jugador : MonoBehaviour
{
    [SerializeField] private float speed = 0;

    private float bounds = 10f;

    // Update is called once per frame
    void Update()
    {
        Move();
    }

    private void Move()
    {
        float moveInput = Input.GetAxisRaw("Horizontal");

        Vector3 playerPosition = transform.position;
        playerPosition.x = Mathf.Clamp(playerPosition.x + moveInput * speed * Time.deltaTime, -bounds, bounds);
        transform.position = playerPosition;
    }
}
