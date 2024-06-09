using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bola : MonoBehaviour
{

    [SerializeField] float speed = 0;
    private Vector3 velocity;
    private bool isBallMoving;

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space) && !isBallMoving)
        {
            transform.parent = null;
            velocity.x = 1;
            velocity.z = 1;
            isBallMoving = true;
        }

        Move(velocity);
    }

    void Move(Vector3 direction)
    {
        transform.position += direction.normalized * speed * Time.deltaTime;
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.tag == "Wall")
        {
            velocity.x *= -1;
        }

        if (collision.gameObject.tag == "Brick")
        {
            if (transform.position.x < collision.transform.position.x - 2 || transform.position.x > collision.transform.position.x + 2)
            {
                velocity.x *= -1;
            }

            else if (transform.position.z < collision.transform.position.z - 2 || transform.position.z > collision.transform.position.z + 2)
            {
                velocity.z *= -1;
            }

            Destroy(collision.gameObject);
        }

        if (collision.gameObject.tag == "Brick" || collision.gameObject.tag == "Player")
        {
            velocity.z *= -1;
        }
    }

}
